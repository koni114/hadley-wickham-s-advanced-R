## chapter09_ 디버깅도구
* Rstudio 디버깅 문서  
https://support.rstudio.com/hc/en-us/articles/200713843-Debugging-with-RStudio

### 9.2 디버깅 도구
#### 9.2.1 호출 시퀀스 결정하기
* f함수가 g 함수를 호출하고, 연속적으로 h와 i를 호출하여 숫자와 문자열을 서로 결합하는 오류를 생성해보자
~~~
f <- function(a) g(a)
g <- function(b) h(b)
h <- function(c) i(c)
i <- function(d) "a" + d
~~~
* 다음과 같이 실행하면 error가 발생함
~~~
 f(10)
~~~
* RStudio에서 Show Traceback과 Rerun with Debug라는 두 가지 옵션이 발생
* Show Traceback을 클릭하면 다음과 같이 나타남
~~~
4. i(c)
3. h(b)
2. g(a)
1. f(10)
~~~
* source() 함수를 이용하고, traceback() 를 사용하면,
filename, r#linenumber의 형태로 함수의 위치 표시

#### 9.2.2 오류 탐색
* interactive debugger : 함수의 실행을 잠시 멈추고, 그것의 상태를 interactive하게 탐색할 수 있도록 해줌
* interactive debugging의 가장 쉬운 방법은 RStudio의 Rerun with Debug 도구를 이용하는 것
* browser() 는 오류가 발생한 환경에서 인터렉티브한 콘솔을 시작함
* 다음과 같이 정의된 browseOnce() 함수로 이 절차를 자동화 할 수 있음
~~~
browseOnce <- function() {
  old <- getOption("error")
  function(){
    options(error = old)
    browser()
  }
}
options (error = browseOnce())
f <- function() stop("!")
f()
f()
~~~
* dump.frame : 현재 작업디렉토리에 last.dump.rda 파일을 생성
* 인터렉티브한 R 세션에서 그 파일을 로드하고, recover()와 동일한 인터페이스의 인터렉티브 디버거로 진입하기 위해 debugger()를 사용해라

### 9.3 상황 처리
#### 9.3.1 try를 이용한 오류 무시
* try()는 오류가 발생한 이후에도 계속 실행할 수 있도록 해 줌
* 오류를 발생시키는 함수를 실행하면 함수는 즉시 종료되고, 값을 반환하지 않음

* error 발생시키는 경우,
~~~
f1 <- function(x){
  log(x)
  10
}
f1("x")
~~~
* try()를 이용
~~~
f2 <- function(x){
  try(log(x))
  10
}
f2("a") # error를 발생시키고, 10 값을 return 함
~~~
* 다중 코드를 try로 감싸려면, {} 이용
~~~
try({
  a <- 1
  b <- "x"
  a + b
  })
~~~
* try() 함수의 출력을 캡처할 수도 있음
* 성공했다면 그 코드 블록에서 평가된 마지막 결과일 것이고, 성공하지 못했다면 try-error 클래스의 객체
~~~
success <- try(1 + 2)
failure <- try("a" + "b")
class(success) # numeric
class(failure) # try-error
~~~
* try는 함수를 리스트의 여러 요소에 적용할 때 유용
~~~
elements <- list(1:10, c(-1, 10), c(T, F), letters)
results  <- lapply(elements, log)
results  <- lapply(elements, function(x) try(log(x))) # error가 나도 results에 값이 저장됨
~~~

~~~
is.error <- function(x) inherits(x, "try-error")
succeed  <- !vapply(results, is.error, logical(1))
str(results[succeed])
str(elements[!succeed])
~~~
* try 사용의 가장 보편적인 방법은 표현식에 error가 발생하는 경우 default로 지정하는 것

~~~
defaults <- NULL
try(defaults <- read.csv("possibly-bad-input.csv"), silent = - [ ] )
~~~

#### 9.3.3 withCallingHandlers()
* tryCatch의 대안으로 withCallingHandlers 함수가 사용될 수 있음
* 두 함수의 핸들러의 차이가 있는데, (여기서의 핸들러는 에러 발생시 제어하는 부분을 말함 )  
try-catch의 핸들러는 tryCatch() 맥락에서 호출되는 반면,
withCallingHandler에서 핸들러는 상황을  호출의 맥락에서 호출
