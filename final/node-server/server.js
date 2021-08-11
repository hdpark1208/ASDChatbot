
// import -------------------------------------------------------------------------------
// 모듈들을 불러오는 부분
// 지정한 모듈이 컴퓨터에 존재하지 않을 시, npm install 모듈명 이라는 명령어를 입력해서 생성해주어야함
const express = require("express"); // 서버생성하는 모듈
const mysql = require("mysql"); // mysql과 연동할 수 있게해주는 모듈
const cors = require("cors");   // http 통신과 관련된 제약사항을 설정하는 모듈
const bodyParser = require("body-parser"); // html 코드를 파싱해주는 모듈
const path = require('path'); // 컴퓨터의 경로 지정
var cookieParser = require('cookie-parser'); // html 코드의 쿠키 부분을 파싱해주는 부분으로 추정
var logger = require('morgan'); // 로그 관리 모듈
const Dialogflow = require('./routes/bot'); // 새로 생성한 모듈을 불러옴
const app = express(); // 서버를 만드는 모듈. app
const fs = require("fs"); // 파일시스템 
const iconv = require("iconv-lite"); // 문자 인코딩 

// --------------------------------------------------------------------------------------

// sleep  구현
function sleep(ms) {
    const wakeUpTime = Date.now() + ms;
    while (Date.now() < wakeUpTime) {}
}


// 서버에서 사용할 수 있도록 지정
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public-flutter')));
app.use(express.json());
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended : true}));

module.exports = app;

// 임시로 변수 생성
let db = null;


// ChatBot에서 필요한 키 넣어둠
botId = "다이얼로그 플로우 프로젝트 ID";
keyPath = "다이얼로그 플로우 프로젝트의 API 키";

// 함수에 지정한 값을 넣고 bot으로 새로 생성
const bot = new Dialogflow(botId, keyPath);


// python model을 불러오는 부분
// require(모듈import)해서 child_process의 spawn을 불러옴
const spawn = require("child_process").spawn;


// 서버의 post부분을 구현한 곳. 동기방식임
// post로 넘겨받은 값을 어떻게 처리할지 적혀있는 
// post -------------------------------------------------------------------------------------------------------------------------------
app.post("/post", async(req, res, next) => {
    console.log("-- POST START -----------------------------------------------------------------------------------------------");
    console.log("User Chat Post Success!");

    // insert query
    const content = req.body.content;
    console.log();
    // sql query
    var insertQuery = "INSERT INTO ChatData (ChatDate, Who, Content) VALUES (NOW(), \"User\", ?);";
    await db.query(insertQuery, [content]);


    // error test 
    // 값을 하나만 보도록 했음
    var selectQuery = await db.query("SELECT * FROM ChatData ORDER BY ChatIndex DESC LIMIT 1;", 
    function(err, result, fields){
        if(err){
            console.log("ERROR!")
        }
        if(result){
            console.log("User Chat Insert Success!")
            console.log(result);
        }
    }) 


    // 파이썬 코드와 관련된 코드
    // model
    console.log("-- Model ----------------------------------------------");
    const result = spawn("python", ["load_lstm.py", content]);
    result.stdout.on("data", (result) => {
        console.log(result.toString());
    });
    // 파이썬 코드를 받음
    const modelResult = fs.readFileSync("modelResult.txt", "binary");
    // 넘겨받은 값이 utf-8이 아니라 깨져서 보이므로 utf-8로 변환해줌
    const decodeData = iconv.decode(modelResult, "euc-kr").toString();
    console.log(decodeData);
    // 지정한 변수에 나쁜말이 포함되어있는지 확인
    // includes는 true/false 값을 반환함
    wordType = decodeData.includes("나쁜말");
    var postText = ""
    // wordType이 True이거나 content 에 지정한 값들이 포함되어있는지 여부에 따라 분기하는 코드
    if (wordType | content.includes("ㅅㅂ", "썅", "ㅂㅅ", "슈발")) {
        // console.log("나쁜말 그만해");
        postText = "엄청엄청심한욕";
    } else {
        // console.log("착한말~");
        postText = content;
    }


    // Dialogflow API 와 관련된 코드
    // bot 
    console.log("-- Bot ----------------------------------------------");
    // 사용할 sql insert 코드
    var botInsertQuery = "INSERT INTO ChatData (ChatDate, Who, Content) VALUES (NOW(), \"Bot\", ?);";

    // 다이얼로그 플로우에 postText에 들어있는 값을 넘김
    // 테스트 해본결과 혼자서 비동기인건지 다른 값들이 다 넘어오고 나서야 봇의 값이 넘어오는 오류가 발생함
    bot.sendToDilogflow(postText, "test-session-id").then(r => {
        // 값이 제대로 넘어오면 실행되는 부분
        outStr = new String(r[0].queryResult.fulfillmentText);
        outText = String(outStr);
        console.log(outText);
        // db에 쿼리 실행하는 부분. 쿼리의 ? 부분에 outText 값을 넣어줌
        db.query(botInsertQuery, [outText]);
    }).catch(e => {
        // 에러가 잡히면 실행되는 부분
        // console.log(e)
    })
    // 서버에서 넘어온 값을 받으면 "ok"라고 값이 넘어온곳에 답을 넘겨줌
    res.json({status:"OK"});
//     sleep(3000);
    console.log("-- POST END -----------------------------------------------------------------------------------------------");
    next();
});
// ------------------------------------------------------------------------------------------------------------------------------------

// get으로 요청받은 값을 넘겨주는 부분이며 동기방식임
// Bot으로 app.get을 Bot이 실행된 이후 실행되도록 .then()을 지정해주거나 post가 일어나고 종료한 이후 실행되도록 해줬지만
// Bot보다 먼저 get이 실행되는 문제가 발생했음. 이부분은 차후 수정해야할듯. 
// get의 문제보다는 bot의 문제가 맞는듯함.
// get --------------------------------------------------------------------------------------------------------------------------------
app.get("/get", async (req, res, next) => {
    // sleep(3000);
    console.log("-- GET START -----------------------------------------------------------------------------------------------");
    console.log("Chat Get Success!")

    // sleep(5000);
    // 서버에 요청했을 때, 100개의 데이터만 넘어가도록 했음
    selectData = await db.query("SELECT * FROM ChatData ORDER BY ChatIndex DESC LIMIT 100;", 
    function(err, result, fields){
        if(err){
            // 에러 넘어오면 실행하는 부분
            console.log("ERROR!")
        }
        if(result){
            // 에러 일어나지 않을때
            console.log("User Chat Insert Success!")
            // console.log(result);
            res.json(result);
        }
    }) 

    // DB에서 넘겨받은 값을 요청에 따라 보내줌
    res.json(selectData);
    console.log("-- GET END -----------------------------------------------------------------------------------------------");
    next();
});
// );
// ------------------------------------------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------------------------------------------
async function main(){
    db = await mysql.createConnection({
        host     : 'localhost', // 호스트
        user     : 'root',      // 사용자명
        password : 'Votmdnjem', // 패스워드
        database : 'DB_CHAT'    // 사용할 데이터 베이스 
    });

    // 3000번 포트에서 app(서버) 실행
    app.listen(3000);
}

main();
