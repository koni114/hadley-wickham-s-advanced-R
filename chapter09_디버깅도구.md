# chapter09 디버깅, 상황 처리, 그리고 방어적 프로그래밍
- 이 장은 예상하지 못한 문제를 수정하는 방법(<b>디버깅: debugging</b>)을 공부하고, 함수가 그 문제를 알려 주는 방법과    
이런 의사소통에 기초하여 취할 수 있는 방안(<b>상황 처리: condition handling</b>)을 제시하며  
마지막으로 문제가 발생하기 전에 공통적인 문제들을 피하는 방법(<b>방어적 프로그래밍: defensive programming</b>)을 다룰 것임
  - 치명적 오류는 `stop()`에 의해 나타나며 모든 실행을 종료함. 오류는 함수가 더 이상 지속할 수 없을 때 사용
  - 경고는 `warning()`으로 생성되고 `log(-1:2)`와 같이 백터화된 입력 요소가 유효하지 않을 때와 같은 잠재적 문제를 표시
  - 메세지는 `message()`로 생성되며 사용자가 쉽게 억제할 수 있는 `suppressMessages()` 방법으로 정보가 있는 출력을 제공하기 위해 사용
- 오류는 항상 <b>Error</b>로 시작하고, 경고는 <b>Warning message</b>로 시작하기 때문에 이 둘은 언제나 구분할 수 있음
- 함수의 제작자는 그 함수의 사용자와 `print()`나 `cat()`으로 대화할 수 있지만, 좋은 생각은 아니다. 그 이유는 일일이 그 결과물들을 캡처하고 선별하는 등의 일이 어렵기 때문
- 출력된 결과물은 상황이 아니므로 다음에 배우게 될 유용한 상황 처리 도구를 사용할 수 없음
- `withCallingHandlers()`, `tryCatch()`, 그리고 `try()`와 같은 상황 처리 도구는 상황이 발생 했을 때 특별한 행동을 취할 수 있도록 해줌
- 방어적 프로그래밍(defensive programming)의 기본 원칙은 무언가 잘못될 때 곧바로 오류를 나타낼 수 있도록 <b>fail fast</b>하는 것
- R에서 이것은 세 가지의 특별한 형태로 나타남
  - 입력이 올바른지 확인하기
  - 비표준적 평가를 파하기
  - 다른 종류의 출력을 반환할 수 있는 함수를 피하기

## 9.1 디버깅 기법
- 다음의 디버깅 절차가 전체를 의미하는 것은 아니지만, 디버깅할 때 생각을 구조화하는 데 도움이 될 수 있음. 
- 4가지 단계로 구성
1. 버그가 있다는 것을 인식해라
- 이것은 고품질의 코드를 작성할 때 반드시 <b>자동화된 테스트 수트(automated tst suites)</b>가 중요한 이유 중 하나
- http://r-pkgs.had.co.nz/tests.html 에서 자세하게 확인 가능

2. 반복 가능하게 해라
- 버그가 있다는 것을 인식했다면, 명령을 따라 재현할 수 있어야 함
- 그렇지 않다면 그 원인을 제거하고 성공적으로 수정했는지 확신하기 어렵게 됨
- 일반적으로 오류의 원인이 된 큰 코드 블록에서부터 시작하여 여전히 오류의 원인이 되는 <b>코드 스니핏</b>으로 천천히 조각냄
- 버그를 생성하는 시간이 오래 걸린다면, 빨리 버그를 생성하는 방법을 고려해야 함
- 만약 자동화된 테스트를 이용하고 있다면, 사례를 생성하기 위한 좋은 기회가 되기도 함

3. 어디에 버그가 있는지 찾아라
- 운이 좋으면 다음 절에서 소개될 도구들 중 하나가 버그의 원이이 되는 코드 줄을 빠르게 찾아내는데 도움이 될 것임
- 보통 이런 버그를 찾는 문제는 더 고민해야 함
- 과학적 방법을 적용하는 것이 훌륭한 아이디어임
- 가설을 설정하고, 그 가설을 검증하기 위해 실험을 계획하고, 그 결과를 기록해라

4. 수정하고 테스트해라
- 버그를 찾았다면 그것을 수정하고 그 수정 방법이 제대로 동작하는지 확인하는 방법을 명확히 할 필요가 있음
- 다시 말하면, 버그를 수정한 방법을 찾은 즉시 자동화된 테스트를 만들어 두는 것이 좋음
- 단지 해당 버그를 수정했다는 것이 아니라, 그 과정에서 새로운 버그가 나타나지 않았다는 것을 확신하는 데에도 도움을 줌

## 9.2 디버깅 도구
- 디버깅 전략을 구현하기 위한 도구가 필요함
- 이번 절에서는 R과 RStudio IDE가 제공하는 도구를 배움
- 핵심적인 디버깅 도구는 다음과 같음
  - RStudio의 <b>오류 추적자(error inspector)</b>와 오류를 유도하는 호출 시퀀스를 나열하는 <b>traceback()</b>
  - RStudio의 <b>Rerun with Debug</b> 도구와 오류가 발생한 인터랙티스 세션을 여는 `options(error = browser)`
  - RStudio의 중단점과 코드 내 임의의 위치에서 인터랙티브한 세션을 여는 `browser()`
- 한 번에 하나의 큰 함수를 작성하려고 하기보다 작은 조각에서 인터랙티브하게 작업해라
- 작게 시작하면 어떤 것이 동작하지 않는 이유를 빠르게 식별할 수 있지만,  
  크게 시작하면 문제의 원천을 식별하는 데 어려움을 겪게 됨

### 9.2.1 호출 시퀀스 결정하기
- 첫 번째 도구는 오류를 유도하는 호출 시퀀스인 호출 스택(call stack)임
- `f()`가 `g()`를 호출하고 연속적으로 `h()`와 `i()`를 호출하여 숫자와 문자열을 서로 결합하는 오류를 생성하는 간단한 사례를 살펴보자
~~~r
f <- function(a) g(a)
g <- function(b) h(b)
h <- function(c) i(c)
i <- function(d) "a" + d
f(10)
~~~
- RStudio에서 이 코드를 실행하면 다음과 같이 나타남
~~~r
 Error in "a" + d : non-numeric argument to binary operator 
~~~
- 오류 오른쪽 메세지에 <b>Show traceback</b>과 <b>Rerun with Debug</b>라는 두 가지 옵션이 나타남
- Show traceback을 클릭하면 다음과 같이 나타남
~~~
4. i(c) 
3. h(b) 
2. g(a) 
1. f(10) 
~~~
- `traceback()`을 이용해서 확인도 가능
- 호출 스택을 아래에서 위로 읽어보자. 최초의 호출인 `f()`는 `g()`, `h()`, `i()` 를 순서대로 호출하는데, 이는 오류를 발생시킴
- `source()`로 코드를 R로 호출하면 traceback은 filename, r#linenumber의 형태로 함수의 위치를 표시할 것임
- `traceback()`은 오류가 발생한 곳을 보여 주지만, 이유를 보여주는 것은 아님
- 다음으로 유용한 도구는 interactive debugger인데, 이것은 함수의 실행을 잠시 멈추고 그것의 상태를 인터랙티브하게 탐색할 수 있도록 해줌

### 9.2.2 오류 탐색
- 인터랙티브 디버거를 시작하는 가장 쉬운 방법은 <b>Rerun with Debug</b> 도구를 이용하는 것
- 이것은 오류가 발생한 곳에서 실행을 중지하고, 오류가 생성한 명령을 다시 실행함
- 그러면 함수 내의 인터랙티브한 상태에 있게 되고, 여기에 정의된 어떤 객체와도 상호작용 할 수 있음
- 대응되는 코드는 편집기에서, 현재 환경 내의 객체는 Environment 영역에서, 그리고 호출 스택은 Traceback 영역에서 볼 수 있으며, 콘솔에서 임의의 R 코드를 실행 할 수 있음
- 종료는 Q를 입력
- 다음과 같은 기능을 사용해서 디버깅이 가능하다
  - Next, 또는 n: 함수에서 다음 단계를 실행한다. n이라는 이름을 가진 변수를 사용하고 있지 않은지 주의하자. 출력하기 위해 `print(n)`을 해보면 됨
  - Step into 또는 s: next와 유사하게 동작하지만, 다음 단계가 함수이면 함수로 진입하여 각 줄을 처리할 수 있음
  - Finish 또는 f: 현재의 루프나 함수의 실행 종료
  - Continue 또는 c: 인터랙티브 디버깅을 벗어나 일반적인 함수를 계속 실행  
  - Stop 또는 Q: 디버깅을 중단하고, 함수를 종료한 후 전역 작업 공간으로 돌아감
- RStudio 이외에 환경에서 이런 방식의 디버깅을 시작하기 위해 오류가 발생했을 때 실행할 함수를 지정하는 error 옵션을 사용할 수 있음
- RStudio의 디버그와 가장 유사한 함수는 `browser()` 인데, 이 함수는 오류가 발생한 환경에서 인터랙티브한 콘솔을 시작함
- 이 함수를 동작시키기 위해 `options(error = browser)`를 사용함
- 이전의 명령을 다시 실행한 후 기본 오류 행동으로 돌아오려면 `options(error = NULL)`을 사용
- 다음과 같이 정의된 `browseOnce()`함수로 이 절차를 자동화할 수 있음
~~~r
browseOnce <- function(){
  old <- getOption("error")
  function(){
    option(error = old)
    browser()
  }
}
options(error = browseOnce())

f <- function() stop("!")
# 브라우저에 진입
f()
# 일반적인 실행
f()
~~~
- error 옵션과 같이 쓸 수 있는 함수는 다음과 같음
  - `recover`는 호출 스택에서 function call stack 을 일일히 확인하면서 error를 수정할 수 있게 해줌. 특히 오류의 근본적 원인이 많은 경우(실행된 함수의 depth가 깊어 구체적인 원인을 알기 어려울 때)에 유용
  - `dump.frame`은 인터렉티브하지 않은 코드에 대한 `recover`와 동일  
    현재 작업 디렉토리에 `last.dump.rda` 파일을 생성하고 인터렉티브한 R 세션에서 그 파일을 로드하고, `recover()`와 동일한 인터페이스의 인터렉티브 디버거로 진입하기 위해 `debugger()`를 사용하면 됨. 이것은 배치 코드의 인터렉티브 디버깅을 가능하게 해줌
~~~r
# R 배치 프로세스에서 ----
dump_and_quit <- function(){
 
  dump.frames(to.file = TRUE)  #- last.dump.rda 파일에 디버깅 정보를 저장
  q(status = 1)                #- 오류 상태에서 R을 종료
}
options(error = dump_and_quit)

# 이후 세션을 시작할 때 ----
load("last.dump.rda")
dubugger()
~~~
- 오류 행동을 기본값으로 재설정하려면 `options(error = NULL)`을 사용
- 그러면 오류가 어떤 메세지를 출력하고 함수의 실행을 중단

### 9.2.3 임의 코드 탐색
- 오류 상태에서 인터렉티브한 콘솔로 진입하는 것 뿐만 아니라 RStudio의 breakpoint이나 `browser()`를 사용하여 어떤 위치의 코드에서도 그 콘솔에 진입할 수 있음
- RStudio에서 줄 번호 왼쪽을 클릭하거나 shift + F9를 이용해 breakpoint 설정 가능
- 이와 동일하게 작동시키려면 해당 위치에 `browser()`를 입력하면 됨
- breakpoint는 두 가지 작은 단점이 존재
  - 중단점이 동작하지 않는 경우가 몇 가지 있음  
    breakpoint troubleshooting 이라는 문서를 읽어보아라
  - `browser()`는 if 구문 내에 어디에나 넣을 수 있지만, RStudio는 현재 조건부 중단점을 지원하지 않음
- `browser()`를 추가할 뿐만 아니라 코드에 추가할 함수가 두 가지 더 있음
  - `debug()`, `undebug()` 를 통해 디버깅모드 시작, 종료를 수행할 수 있음
  - `utils::setBreakPoint()`도 유사하게 작동하지만 함수 이름 대신 파일 이름, 줄 번호를 입력받아 적절한 함수를 찾음 
- 이들 두 함수는 모두 `trace()`의 특수한 사례인데, 임의의 코드를 기존 함수의 어느 곳이든 삽입함
- `trace()`는 정보가 없는 코드를 디버깅할 때 유용
- 함수에서의 추적을 제거하려면 `untrace()`를 사용
- 함수당 하나의 `trace()`를 수행할 수 있지만, 그 하나의 trace는 복수의 함수 호출 가능

### 9.2.4 호출 스택: traceback(), where, 그리고 recover()
- `traceback()`, `browser() + where`, `recover()`로 출력된 호출 스택은 동일하지 않음
- 다음은 각각 출력되는 호출 스택임
~~~r
# 1. traceback()
4: stop("Error")
3: h(x)
2: g(x)
1: f()

# 2. Where
where 1: stop("Error")
where 2: h(x)
where 3: g(x)
where 4: f()

# 3. recover()
1: f()
2: g(x)
3: h(x)
~~~
- `traceback()`과 where의 경우에 번호가 다르게 매겨지고, `recover()`는 반대로 호출되고 stop을 생략함
- RStudio는 `traceback()`과 같은 순서로 호출을 표시하지만, 번호는 생략

### 9.2.5 실패의 다른 유형
- 오류나 부정확한 결과를 내뱉는 것과는 별도로 함수가 실패하는 경우가 있음
- warning을 추적하는 가장 쉬운 방법은 `options(warn = 2)`로 변경하고 정규 디버깅 도구를 사용하는 것
- 그러면 호출 스택에서 `doWithOneRestart()`, `withOneRestart()`, `withRestarts()`, `signalSimpleWarning()` 같은 호출을 추가로 보게 될 것임
- 이것들은 무시해도 됨. 그 이유는 위의 함수들은 warning을 error로 변경하기 위해서 사용된 함수들이기 때문
- 어떤 함수가 예상하지 못한 메세지를 나타낼 수 있음
- 이 문제를 해결할 내장 도구는 없지만 하나 생성할 수는 있음
~~~r
message2error <- function(code){
  withCallingHandler(code, message = function(e) stop(e))
}

f <- function() g()
g <- function() message("Hi!")
g()
#> Hi !

message2error(g())
# Error in message("Hi!"): Hi!
traceback()
~~~

#### 함수가 절대 종료되지 않을 때
- 이런 경우 자동으로 디버깅하기 어렵지만, 그 함수를 종료하고 호출 스택에서 찾는 것이 유익할 때가 있음
- 그렇지 않으면 기본적인 디버깅 전략을 이용하자

#### R을 완전히 종료해 버릴 때
- 이것은 밑바닥에 있는 C 코드에 버그가 있다는 것을 말함
- 이런 C코드를 디버깅하는 것은 쉽지 않음
- 때로 GNU Debugger와 같은 인터렉티브 디버거가 유용할 수 있음

## 9.3 상황 처리
- R에서는 프로그램적으로 상황을 처리할 수 있는 도구가 3가지가 있음
  - `try()`는 오류가 발생하더라도 계속 실행
  - `tryCatch()`는 상황이 발생할 때 일어나는 일들을 제어하는 <b>핸들러(handler)</b> 함수 지정
  - `withCallingHandlers()`는 지역 핸들러를 설정하는 `tryCatch()`의 변형  
    반면 `tryCatch()`는 종료 핸들러를 등록함.   
    로컬 핸들러는 함수 실행을 종료하지 않고 상황이 나타난 곳과 동일한 맥락에서 호출됨  
    `tryCatch()`에서 종료 핸들러가 호출되면 함수의 실행은 중단되고 그 핸들러가 호출됨  
    `withCallingHandlers()`는 거의 필요하지 않지만, 알아 두면 유용함ㄴ

### 9.3.1 try를 이용한 오류 무시
- `try()`는 오류가 발생한 이후에도 계속 실행할 수 있도록 해줌
- 오류를 발생시키는 함수를 실행하면 그 함수는 즉시 종료되고, 값을 반환하지 않음
~~~r
f1 <- function(x){
  log(x)
  10
}
f1("x")
~~~
- 오류를 생성하는 구문을 `try()`로 감싸면 오류 메세지가 출력되기는 하지만, 실행은 계속됨
~~~r
f2 <- function(x){
  try(log(x))
  10
}
f2("a")
#> Error in log(x) : non-numeric argument to mathematical function
#> [1] 10
~~~
- 오류 메세지는 `try(..., silent = TRUE)`로 억제 할 수 있음
- 여러 줄을 try 함수로 감싸려면 {} 사용
~~~r
try({
  a <- 1
  b <- "x"
  a + b
})
~~~
- `try()`함수의 출력을 캡처할 수도 있음
- 성공했다면 그 코드 블록의 마지막 결과일 것이고, 성공하지 못했다면 <b>try-error</b> 클래스의 객체일 것임
~~~r
success <- try(1 + 2)
failure <- try("a" + "b")
class(success)
#> [1] "numeric"

class(failure)
#> [1] "try-error"
~~~
- `try()`는 특히 함수를 리스트의 여러 요소에 적용할 때 유용
~~~r
elements <- list(1:10, c(-1, 10), c(TRUE, FALSE), letters)
results <- lapply(elements, log)

#> Error in FUN(X[[i]], ...) : non-numeric argument to mathematical function
#> In addition: Warning message:
#> In FUN(X[[i]], ...) : NaNs produced

results <- lapply(elements, function(x) try(log(x)))
#> Warning in log(x): NaNs produced
~~~
- try-error 클래스를 테스트하기 위한 내장 함수는 없으므로 하나를 정의할 것임
- 이제 `sapply()`로 오류의 위치를 쉽게 찾을 수 있으므로, 성공한 것을 추출하거나 실패를 유도한 입력을 찾아보라
~~~r
is.error <- function(x) inherits(x, "try-error")
succeed <- !vapply(results, is.error, logical(1))

str(results[succeed])   #- 성공한 결과
str(elements[!succeed]) #- 실패한 결과
~~~
- `try()` 사용의 유용한 방법 중 하나는 표현식이 실패하는 경우 default 값을 사용하는 것
~~~r
default <- NULL
try(default <- read.csv("haha.csv"), slient = TRUE)
~~~
- `plyr::failwith()` 이러한 전략을 훨씬 쉽게 구현할 수 있도록 해줌

### 9.3.2 tryCatch()를 이용한 상황 처리
- `tryCatch()` 는 오류 이외에도 경고, 메세지, 중단의 경우에 따라 다른 행동을 취할 수 있음
- 중단은 프로그래머에 의해 직접 생성될 순 없지만, 사용자가 Ctrl + Break, Escape, Ctrl + C를 눌러 실행을 종료하고자 할 때 발생 
- `tryCatch()`는 입력으로 함수를 호출하는 것과 같이 특정 문제로 호출된 이름 있는 함수인 <b>핸들러</b>에 상황을 매핑함
- 상황이 나타나면 `tryCatch()`는 상황의 클래스 중 하나와 이름이 매치되는 핸들러 호출
- 내장된 이름 중 `error`, `warning`, `message`, `interrupt`, `condition` 이 유용함
- 핸들러 함수는 전형적으로 값을 반환, 보다 정보가 많은 오류 메세지를 생성할 것임
- 예를 들어, 다음 `show_condition()`함수는 나타난 상황의 유형을 반환하는 핸들러 설정 
~~~r
show_condition <- function(code){
  tryCatch(code, 
  error = function(c) "error",
  warning = function(c) "warning",
  message = function(c) "message"
  )
}

show_condition(stop("!"))
#> [1] error

show_condition(warning("?!"))
#> [1] warning

show_condition(message("?"))
#> [1] message

# tryCatch는 상황이 파악되지 않으면 입력된 값을 반환
show_condition(10)
#> [1] 10
~~~
- 문제가 나타났을 때 기본값을 반환하는 것 뿐만 아니라 정보가 많은 오류 메세지를 만드는 데 핸들러 사용 가능
- 예를 들어 아래 함수는 어떤 오류에 파일 이름을 추가하기 위해 <b>오류 상황 객체(error condition object)</b>에 저장된 메세지를 수정하여 <b>read.csv()</b>를 래핑함
~~~r
read.csv2 <- function(file, ...){
  tryCatch(read.csv(file, ...), error = function(c){
    c$message <- paste0(c$message, "(in ", file, ")")
    stop(c)
  })
}

read.csv("code/dummy.csv")
#> Error in file(file, "rt") : cannot open the connection

read.csv2("code/dummy.csv")
#> Error in file(file, "rt") : cannot open the connection (in code/dummy.csv)
~~~
- 사용자가 실행 중인 코드를 중단하길 시도할 때 특별한 행동을 취하길 원한다면,  
  <b>중단을 파악하는 것(catching interrupts)이 유용</b>할 수 있음
- 그러나 R을 중단하기 전까지 무한 루프를 생성하기 쉽다는 점에 주의해야 함
~~~r
#- 사용자가 코드를 중단하지 않게 해야함
i <- 1
while(i < 3){
  tryCatch({
    Sys.sleep(0.5)
    message("Try to escape")
  }, interrupt = function(x){
    message("Try again!")
    i <<- i + 1
  })
}
~~~
- `tryCatch()`는 finally라는 인자도 가지고 있음
- finally는 오류나 실행 여부와 상관 없이 실행하기 위한 코드 블록을 지정
- 이 인자는 깨끗이 정리(예를 들어, 파일을 삭제하고 연결을 종료하는 것과 같이)하는데 유용함
- 이것은 기능적으로 `on.exit()`를 사용하는 것과 동등하지만 전체 함수가 아니라 작은 코드 청크를 래핑할 수 있음

### 9.3.3 withCallingHandlers()
- `tryCatch()` 대안은 `withCallingHandlers()`임
- 둘 사이의 차이는, 후자는 지역 핸들러를 등록하는 반면, 전자는 탈출 핸들러를 구축함
- 이들 핸들러 사이에는 중요한 차이가 있음
- `tryCatch()`의 핸들러가 `tryCatch()` 맥락에서 호출되는 반면 `withCallingHandlers()`에서 핸들러는 상황을 생성한 호출의 맥락에서 호출됨
- 여기서는 `sys.calls()`로 보여지는데, 이것은 `traceback()`의 런타임과 동등함
- 즉, 이것은 현재 함수에 앞선 모든 호출을 나열함
~~~r
f <- function() g()
g <- function() h()
h <- function() stop("!")

tryCatch(f(), function(e) print(sys.calls()))

#> [[1]]
#> tryCatch(f(), error = function(e) print(sys.calls()))

#> [[2]]
#> tryCatchList(expr, classes, parentenv, handlers)

#> [[3]]
#> tryCatchOne(expr, names, parentenv, handlers[[1L]])

#> [[4]]
#> value[[3L]](cond)

withCallingHandlers(f(), error = function(e) print(sys.calls()))

#>[[1]]
#> withCallingHandlers(f(), error = function(e) print(sys.calls()))

#> [[2]]
#> f()

#> [[3]]
#> function() g()

#> [[4]]
#> function() h()

#> [[5]]
#> function() stop("!")

#> [[6]]
#> .handleSimpleError(function(e) print(sys.calls()), "!", 
#>   base::quote(h()))

#> [[7]]
#> h(simpleError(msg, call))
~~~
- 이는 `on.exit()`가 호출된 순서에도 영향을 미침
- `tryCatch()`의 경우 실행 흐름이 핸들러가 호출될 때 중단됨
- `withCallingHandlers()`의 경우 핸들러가 반환할 때 정상적으로 실행을 지속함
- 여기에는 핸들러가 호출된 이후에 원래의 과정을 지속하는 신호 함수(the signaling function)가 포함(예를 들어, `stop()`은 프로그램을 계속 중단하고 `message()` 또는 `warning()`은 메세지/경고 표시를 계속할 것임)
- `tryCatch()`는 프로그램을 중단하기 때문에 이보다 `withCallingHandlers()`로 메세지를 처리하는 것이 더 중요한 이유
~~~r
message_handler <- function(c) cat("Caught a message! \n")

tryCatch(message = message_handler, {
  message("Someone there?")
  message("Why, yes!")
})

#> Caught a message!

withCallingHandlers(message = message_handler, {
  message("Someone there?")
  message("Why, yes!")
})

#> Caught a message! 
#> Someone there?
#> Caught a message! 
#> Why, yes!
~~~
- 핸들러의 반환값은 `tryCatch()`에 의해 반환된 값
- 반면 `withCallingHandlers()`는 무시됨
~~~r
f <- function() message("!")
tryCatch(f(), message = function(m) 1)
#> [1] 1

withCallingHandlers(f(), message = function(m) 1)
#> !
~~~
- 무엇이 잘못되어 다른 함수에 전달되는지를 정확히 파악하려고 할 때를 제외하고, 이런 미묘한 차이는 거의 유용하지 않음. 대부분의 목적으로는 절대로 `withCallingHandlers`를 사용할 필요가 없음

### 9.3.4 사용자 정의 신호 클래스
- R의 오류 처리에 있어 어려운 점 한가지는 대부분의 함수가 단지 문자열로 `stop()`을 호출한다는 것
- 이것은 어떤 특수한 오류가 발생했는지를 파악하고자 할 때 오류 메세지의 텍스트를 찾아봐야 한다는 것을 의미
- 많은 오류 메세지가 번역되기 때문에 해석 과정에서 문제를 발생시키기 쉬우며, 그러므로 메세지가 기대하는 것과는 완전히 다를 수도 있음
- R에는 이러한 문제를 해결할 수 있는 방법이 거의 없음
- 특정 상황(error, message, warning등)은 S3 클래스이므로 다른 여러 종류들의 오류를 서로 구분하길 원한다면 자신만의 클래스를 정의할 수 있음
- `stop(), warning(), message()` 같은 상황 신호 함수는 문자열 목록이나 사용자 정의 S3 상황 객체로 주어질 수 있음
- 사용자 정의 상황 객체는 자주 사용되지는 않지만, 사용자가 오류에 따라 다른 방법으로 대응할 수 있게 해주기 때문에 매우 유용함
- 예를 들어 어떤 입력 데이터 세트에 대한 모형 수렴이 실패한 경우와 같은 <b>예측된 오류</b>는 아무런 표시 없이 무시될 수 있음. 반면 디스크 공간 부족과 같은 기대하지 못한 오류가 사용자에게 전달될 수 있음
- R에는 상황에 대한 내장된 생성자 함수는 없지만, 쉽게 하나를 추가할 수 있음
- 상황은 반드시 구성 요소로 message와 call을 포함해야 하고, 다른 유용한 요소를 추가할 수 있음
- 새로운 상황을 생성할 때 그것은 항상 상황을 상속하고 대부분의 경우 error, warning, message 중 하나를 상속해야 함
~~~r
condition <- function(subclass, message, call = sys.call(-1), ...){
  structure(
    class = c(subclass, "condition")
    list(message = message, call = call),
    ...
  )
}
is.condition <- function(x) inherits(x, "condition")
~~~
- 임의의 상황을 `signalCondition()`으로 나타낼 수 있지만, 사용자 정의 신호 핸들러를 예시하지 않는 한 아무 일도 일어나지 않음
- 대신 일반적인 상황 처리를 유도하는 데 적절한 `stop()`, `warning()`, `message()`에 이 상황을 전달해라
- 사용자 상황의 클래스가 함수와 매치되지 않아도 R은 무리 없이 동작하지만 , 실제 코드에서는 적절한 클래스, 즉 `stop()`에 대해서는 error, `warning()`에 대해서는 warning, `message()`에 대해서는 message를 상속하는 상황을 전달해야 함
~~~r
e <- condition(c("my_error", "error"), "This is an error") #- error 클래스의 conditon 객체
signalCondition(e)
#- NULL
stop(e)
# Error: This is an error

w <- condition(c("my_warning", "warning"), "This is a warning")
warning(w)
# Warning message: This is a warning

m <- condition(c("my_message", "message"), "This is a message")
message(m)
# This is a message
)
~~~
- 여러 유형의 오류에 따라 다른 행동을 취하기 위해 `tryCatch()`를 사용할 수 있음
- 다음의 사례에서 임의의 클래스로 오류 상황을 나타낼 수 있는 편리한 함수인 `custom_stop()`을 만듬
- 실제 적용에 있어서는 보다 자세히 오류 클래스를 설명하는 문서를 만들 수 있는 개별적인 S3 생성자 함수를 만드는 것이 좋음
~~~r
custom_stop <- function(subclass, message, call = sys.call(-1), ...){
  c <- condition(c(subclass, "error"), message, call = call, ...)
  stop(c)
}

my_log <- function(x){
  if (!is.numeric(x)){
    custom_stop("invaild_class", "my_log() needs numeric input")
  }
  if (any(x < 0)){
    custom_stop("invaild_value", "my_log() needs positive inputs")
  }
log(x)
}

tryCatch(
  my_log("a"),
  invalid_class = function(c) "class",
  invalid_value = function(c) "value"
)
#> [1] class
~~~
- 다수의 핸들러와 사용자 정의 클래스로 `tryCatch()`를 사용할 때 신호 클래스 계층에서 어떤 클래스와 일치하는 첫 번째 핸들러가 호출되는 것에 주의하자
- 이런 이유 때문에 가장 구체적인 핸들러를 정확히 먼저 삽입할 필요성이 있음
~~~r
tryCatch(custom_stop("my_error", "!"),
  error = function(c) "error",
  my_error = function(c) "my_error"
)
#> [1] error

tryCatch(custom_stop("my_error", "!"),
  my_error = function(c) "my_error",
  error = function(c) "error"
)
#> [1] my error
~~~

## 9.4 방어적 프로그래밍
- 방어적 프로그래밍(defensive programming)은 예상하지 않은 어떤 일이 발생했을 때도  
  코드가 잘 정의된 방법으로 실패하도록 만드는 기법
- 방어적 프로그래밍의 핵심 원칙은 <b>빠르게 실패(fail fast)</b>임
- 무엇인가 잘못된 것이 발견된 순간 바로 오류를 나타내는 것을 말함
- 이것은 함수 제작자에게 더 효과적이지만, 사용자가 디버깅을 보다 더 쉽게 할 수 있음
- 왜냐하면 예상하지 못한 입력이 여러 함수를 통해 전달된 이후에 상태에서 빨리 오류를 얻을 수 있기 때문
- R에서 <b>빠른 실패 원칙</b>은 세 가지 방법으로 구현

#### 1. 허용할 것에 엄격해라
- 예를 들면 자신의 함수가 그 입력이 벡터화된 것처럼 함수를 사용한다면 그 입력이 스칼라인지를 확인하도록 해라
- assertthat 패키지의 `stopifnot()`, 단순하게 if구문과 `stop()`을 사용할 수 있음

#### 2. 비표준적 평가를 사용하는 함수를 피해라
- `subset`, `transform`, `with` 와 같은 비표준적 평가를 사용하는 함수를 피해라
- 타이핑을 감소시키기 위한 여러 가정들을 하고 있기 때문에 실패했을 때 정보가 부족한 오류 메세지를 반환함

#### 3. 입력에 따라 다른 유형의 출력을 반환하는 함수를 피해라
- 입력에 따라 다른 유형의 출력을 반환하는 함수를 피해라
- 이런 종류의 함수 중 가장 빈번하게 사용되는 것은 <b>[ 와 sapply()</b> 임
- 함수로 데이터 프레임을 서브세팅할 때 항상 drop = FALSE를 사용해야 하는데,  
  그렇지 않으면 우연히 열이 한 개인 데이터 프레임을 벡터로 변환할 것임ㄴ
- 유사하게 함수 내에서 절대로 `sapply()`를 사용하지마라
- 즉 입력이 부적절한 유형이면 오류를 내고, 심지어 길이가 0인 입력의 경우에서 조차도 올바른 유형의 출력을 반환하는 보다 엄격한 함수인 `vapply()`를 사용해라


## 용어 정리
- 인터랙티스(interactive)
  - 인터(Inter)와 액티브(Active)의 합성어인 인터랙티브의 사전적 의미는 ‘상호적인’, ‘상호작용을 하는’으로, <b>사용자의 요청에 반응해 마치 대화하듯 데이터를 입출력할 수 있는 일종의 프로그램</b>