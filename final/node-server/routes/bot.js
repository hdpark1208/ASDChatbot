const dialogflow = require("dialogflow");
// const session = require("express-session");
const fs = require("fs");
// var express = require('express');
// var router = express.Router();

class Dialogflow {
    constructor(projectId, keyFile){
        this.projectId = projectId;
        const keyfile = JSON.parse(fs.readFileSync(keyFile));

        let privateKey = keyfile["private_key"];
        let clientEmail = keyfile["client_email"];

        let config = {
            Credential:{
                private_key : privateKey,
                client_email : clientEmail
            }
        }

        this.sessionClient = new dialogflow.SessionsClient(config)
    };
    
    async sendToDilogflow(text, sessionId){
        const sessionPath = this.sessionClient.sessionPath(this.projectId, sessionId);

        const request = {
            session: sessionPath,
            queryInput:{
                text : {
                    text: text,
                    languageCode: "ko-KR"
                }
            }
        };
        
        return await this.sessionClient.detectIntent(request);
    }
}

// export
module.exports = Dialogflow

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
