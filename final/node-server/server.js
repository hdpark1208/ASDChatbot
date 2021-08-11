
// import -------------------------------------------------------------------------------
const express = require("express");
const mysql = require("mysql");
const cors = require("cors");
const bodyParser = require("body-parser");
const path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
const Dialogflow = require('./routes/bot');
const app = express();
const fs = require("fs");
const iconv = require("iconv-lite");

// --------------------------------------------------------------------------------------

function sleep(ms) {
    const wakeUpTime = Date.now() + ms;
    while (Date.now() < wakeUpTime) {}
}


app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public-flutter')));

let db = null;


app.use(express.json());
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended : true}));

module.exports = app;

// ChatBot
botId = "chatbottest2-9yon";
keyPath = "./chatbottest2-9yon-3782ffd5b607.json";

const bot = new Dialogflow(botId, keyPath);


// python model
const spawn = require("child_process").spawn;


// post -------------------------------------------------------------------------------------------------------------------------------
app.post("/post", async(req, res, next) => {
    console.log("-- POST START -----------------------------------------------------------------------------------------------");
    console.log("User Chat Post Success!");

    // insert query
    const content = req.body.content;
    console.log();
    var insertQuery = "INSERT INTO ChatData (ChatDate, Who, Content) VALUES (NOW(), \"User\", ?);";
    await db.query(insertQuery, [content]);


    // error test
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


    // model
    console.log("-- Model ----------------------------------------------");
    const result = spawn("python", ["load_lstm.py", content]);
    result.stdout.on("data", (result) => {
        console.log(result.toString());
    });
    const modelResult = fs.readFileSync("modelResult.txt", "binary");
    const decodeData = iconv.decode(modelResult, "euc-kr").toString();
    console.log(decodeData);
    wordType = decodeData.includes("나쁜말");
    var postText = ""
    if (wordType | content.includes("ㅅㅂ", "썅", "ㅂㅅ", "슈발")) {
        // console.log("나쁜말 그만해");
        postText = "엄청엄청심한욕";
    } else {
        // console.log("착한말~");
        postText = content;
    }


    // bot 
    console.log("-- Bot ----------------------------------------------");
    var botInsertQuery = "INSERT INTO ChatData (ChatDate, Who, Content) VALUES (NOW(), \"Bot\", ?);";

    bot.sendToDilogflow(postText, "test-session-id").then(r => {
        outStr = new String(r[0].queryResult.fulfillmentText);
        outText = String(outStr);
        console.log(outText);
        db.query(botInsertQuery, [outText]);
    }).catch(e => {
        // console.log(e)
    })
    res.json({status:"OK"});
    sleep(3000);
    console.log("-- POST END -----------------------------------------------------------------------------------------------");
    next();
});
// ------------------------------------------------------------------------------------------------------------------------------------

// get --------------------------------------------------------------------------------------------------------------------------------

app.get("/get", async (req, res, next) => {
    // sleep(3000);
    console.log("-- GET START -----------------------------------------------------------------------------------------------");
    console.log("Chat Get Success!")

    // sleep(5000);
    selectData = await db.query("SELECT * FROM ChatData ORDER BY ChatIndex DESC LIMIT 100;", 
    function(err, result, fields){
        if(err){
            console.log("ERROR!")
        }
        if(result){
            console.log("User Chat Insert Success!")
            // console.log(result);
            res.json(result);
        }
    }) 

    res.json(selectData);
    console.log("-- GET END -----------------------------------------------------------------------------------------------");
    next();
});
// );
// ------------------------------------------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------------------------------------------
async function main(){
    db = await mysql.createConnection({
        host     : 'localhost',
        user     : 'root',
        password : 'Votmdnjem',
        database : 'DB_CHAT'
    });

    app.listen(3000);
}

main();
