const dialogflow = require("dialogflow");
const fs = require("fs");

class Dialogflow {
    constructor(projectId, keyFile){
        this.projectId = projectId;
        // 불러들인 값을 새롭게 파싱함
        const keyfile = JSON.parse(fs.readFileSync(keyFile));

        // 넘겨받은 키값과 이메일을 담아둠
        let privateKey = keyfile["private_key"];
        let clientEmail = keyfile["client_email"];

        // dialogflow에 넘겨줄 값 설정
        let config = {
            Credential:{
                private_key : privateKey,
                client_email : clientEmail
            }
        }

        // 다이얼로그 플로우의 clientSession에 지정한 값을 넘겨주고 새롭게 생성해서 담아둠
        this.sessionClient = new dialogflow.SessionsClient(config)
    };
    
    // 다디얼로그 플로우에 값을 보내는 부분
    async sendToDilogflow(text, sessionId){
        // 다이얼로그 플로우의 아이디와 세션 아이디를 통해 경로를 지정함
        const sessionPath = this.sessionClient.sessionPath(this.projectId, sessionId);

        // 넘겨 받을 값의 형태 지정
        const request = {
            session: sessionPath,
            queryInput:{
                text : {
                    text: text,
                    languageCode: "ko-KR"
                }
            }
        };
        
        // 넘겨받은 값으로 실행한 결과를 서버로 넘겨주는 부분
        return await this.sessionClient.detectIntent(request);
    }
}

// export
// 외부에서도 해당 모듈의 클래스를 사용하도록 함
module.exports = Dialogflow


// 테스트 코드
// 서버에서 사용하지 않고 해당 모듈만 테스트하고 싶을 때 사용하는 코드
// 자세한 설명은 서버에 적혀있음
// // text test --------------------------------------------------------------
// inText = "테스트"
// let outText;

// // env
// // $env:GOOGLE_APPLICATION_CREDENTIALS="./chatbottest2-9yon-3782ffd5b607.json"
// botId = "chatbottest2-9yon"
// keyPath = "./chatbottest2-9yon-3782ffd5b607.json"

// // run
// const test = new Dialogflow(botId, keyPath)
// test.sendToDilogflow(inText, "test-session-id").then(r => {
//     outStr = new String(r[0].queryResult.fulfillmentText);
//     outText = String(outStr);
//     // console.log("TEST PRINT")
//     // console.log(outText)

//     // // export
//     // exports.value = {
//     //     In : inText,
//     //     Out : outText,
//     //     // txt : console.log(outText)
//     // }
//     console.log(outText);
// }).catch(e => {
//     console.log(e)
// })

// // console.log(inText)
// // console.log(outText)

// // exports.value = {
// //     In : inText,
// //     Out : outText
// // }

// // console.log("REAL ----------------------")
// console.log(outText)
