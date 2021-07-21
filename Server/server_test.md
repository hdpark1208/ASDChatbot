# 서버 오픈 테스트

### 테스트 코드
```{javascript}
// SERVER TEST

const http = require('http');
const hostname = '로컬IP';
const port = 오픈포트번호;

http.createServer((req, res) => {
    res.write("<h1>SERVER TEST</h1>");
    res.end("server open!");;
}).listen(port, hostname, () => {
    console.log("서버가 열렸습니다!")
})
```
### 결과
- 문제없이 서버 열리는 것 확인
- 원격에서도 접속 가능한 것 확인
<br>

### 서버 실행 이미지
</br>

![image](https://user-images.githubusercontent.com/84709773/126473660-5a94620f-6ba5-4294-955e-edc0cea1ede3.png)
