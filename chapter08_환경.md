# chapter08 환경
- <b>환경(environment)</b>는 스코핑을 가능케 하는 <b>데이터 구조</b> 
- 앞으로 편의를 위해 env이라고 부르겠다(사전적 의미와는 완전히 다르기 때문)
- 환경은 참조 시멘틱스를 가지기 때문에 그 스스로가 매우 유용한 데이터 구조가 될 수 있음
- 어떤 환경에서 <b>바인딩(binding)</b>을 수정할 때 환경은 복사되지 않고 바로 수정됨

## 8.1 환경 기초
- env의 역할은 값의 집합에 이름(주소)의 집합을 연결 또는 바인딩 하기 위한 것
- env은 <b>이름 주머니</b>라고 생각할 수 있음
~~~
---------
|  b   a |
|        | 
|  c   d |
--------
~~~
- 각 이름은 메모리 어딘가에 저장되어 있는 객체를 말함
~~~r
e <- new.env()
e$a <- FALSE
e$b <- "a"
e$c <- 2.3
e$d <- 1:3

# 구성
"a" < ---  b
2.3 <----  c
FALSE <--- a
1,2,3 <--- d
~~~
- 이 객체는 env에 있지 않으므로 복수의 이름이 같은 객체를 가리킬 수 있음
~~~r
e$a <- e$d

# 구성
1,2,3 <--- a
  ^------- d
2.3 <----  c
"a" < ---  b
~~~
- 혼란스럽지만 env는 같은 값을 가지는 다른 객체를 가리킬 수도 있음
~~~r
e$a <- 1:3

# 구성
1,2,3 <--- a
1,2,3 <--- d
2.3 <----  c
"a" < ---  b
~~~
- 객체가 그것을 가리키는 이름을 갖고 있지 않으면 자동으로 <b>가비지 콜렉터(garbage collector)에 의해 삭제됨</b>
- 모든 env는 부모로 다른 env를 가짐. 
- 이 부모는 렉시칼 스코핑을 구현하기 위해 사용됨. 어떤 이름이 특정 env에서 발견되지 않으면 R은 그것의 부모를 찾고, 이런 작업을 반복할 것임
- 오로지 하나의 env만 부모를 가지지 않는네 이를 공환경(empty environment)라고 함
- env을 참조하기 위해 가족에 비유해 설명함
- env의 할아버지는 env의 부모의 부모이고, 조상은 empty env까지의 모든 부모 env을 포함함
- env의 자손에 대해 이야기하는 경우가 거의 없는 이유는 아래로의 연결고리가 없기 때문
- 즉 env가 주어졌을 때 env의 자손을 찾을 방법은 없음
- 해당 중요한 4가지가 env가 list와의 차이점을 내포하고 있음
  - env의 모든 객체는 유일한 이름을 가짐
  - env 내의 객체에는 순서가 없음(즉 어떤 env에서 처음 객체가 무엇인지 찾는 것은 의미가 없음)
  - env는 부모를 가짐
  - env는 reference semantics를 가짐
- 보다 기술적으로 설명하면 env는 두 가지 요소로 구성되어 있는데, 하나는 name-object binding을 포함하고 있는 frame이고, 다른 하나는 부모 env임
- frame은 R에서 일관되게 사용되지 않음
- 예를들어 `parent.frame()`은 env의 부모 프레임을 제공하지 않음. 대신에 calling env를 제공
- 네 가지 특수한 env가 있음
  - `globalenv()`, 또는 전역 환경(global env)은 인터렉티브한 작업 공간  
    이 env는 일반적인 작업 env. <b>전역 환경의 부모는 `library()` 또는 `require()`로 붙인 마지막 패키지</b> 
  - `baseenv()`, 또는 <b>베이스 환경(base environment)는 base 패키지의 환경.</b> 그 부모는 공환경임
  - `emptyenv()` 또는 공환경은 모든 env의 궁극적인 조상이며, 부모가 없는 유일한 env
  - `environment()`는 현재의 환경
- `search()`는 전역 env의 모든 부모를 열거함. 이것은 env 내의 객체가 최상위 인터렉티브 작업 공간에서 찾아질 수 있기 때문에 검색 경로(search path)라고 함
- 이 작업 공간은 첨부된 각 패키지에 대한 하나의 env와 `attach()`로 붙여진 다른 객체까지 포함
- 또한 `Autoloads`라는 특수한 env까지 포함되는데, 이는 필요할 때만 패키지 객체를 로딩함으로써 메모리를 절약하는데 사용
- `as.environment()`를 사용하면 검색 목록에 관한 환경에 접근할 수 있음
~~~r
search()
#> [1] ".GlobalEnv"        "package:pryr"      "package:stats4"    "tools:rstudio"     
#>  "package:stats"     "package:graphics"  "package:grDevices" "package:utils"    
#>  [9] "package:datasets"  "package:methods"   "Autoloads"         "package:base" 

as.environment("package:stats")
#> <environment: package:stats>
~~~
- `globalenv()`, `baseenv()`, 검색 경로에 관한 환경, `emptyenv()`는 아래에 보는 것과 같이 연결되어 있음
- <b>패키지는 library()로 새로운 패키지를 로딩할 때마다 전역 환경과 검색 경로의 최상위에 있던 이전 패키지 사이에 삽입됨</b>
~~~
globalenv() --(library 로딩시 추가 위치)-> packages() --> packages() --> ... baseenv() --> emptyenv()
~~~
- 환경을 직접 생성하려면 `new.env()`를 생성해라
- `ls()`로 env frame에서 바인딩을 열거할 수 있고 `parent.env()`로 그 부모를 확인 할 수 있음 
~~~r
e <- new.env()
#- new.env()에 의해 제공된 기본 부모는 호출된 것으로부터의 환경. 이 경우에는 전역 환경
parent.env(e)
#> <environment: R_GlobalEnv>
ls(e) #- ls : List Objects
#> character(0)
~~~
- env에서 바인딩을 수정할 수 있는 가장 쉬운 방법은 리스트처럼 다루면 됨
~~~r
e$a <- 1
e$b <- 2
ls(e)
#> [1] "a" "b"

e$a 
#> [1] 1
~~~
- 기본적으로 `ls()`는 오로지 .으로 시작하지 않는 이름만 보여줌 
- 어떤 env의 모든 바인딩을 보려면 `all.names = TRUE`를 사용해라
~~~r
e$.a <- 2
ls(e)
#> [1] "a" "b"

ls(e, all.names = TRUE)
#> [1] "a" ".a" "b"
~~~
- env을 확인하는 다른 유용한 방법은 `ls.str()`임 이것이 `str()`보다 유용한 이유는 env 내의 각 객체를 보여 주기 때문. `ls()`처럼 이 함수도 all.names 인자를 가짐 
~~~r
str(e)
#> <environment: 0x000000000dd0a3f0> 

ls.str(e)
#> a :  num 1
#> b :  num 2
~~~
- 이름이 주어지면 `$`, `[[`, 또는 `get()`으로 바인딩되어 있는 값을 추출 할 수 있음
- `$`, `[[` 와 `get()`는 차이점이 존재
  - `$`와 `[[`는 하나의 env을 찾아보고, 이름과 연관된 바인딩이 없을 때 NULL을 반환
  - `get()`은 정규 스코핑 규칙을 사용하여 바인딩이 없을 때 오류를 반환
~~~r
e$c <- 3
e$c 
#> [1] 3

e[["c"]]
#> [1] 3

get("c", envir = e)
#> [1] 3
~~~
- env에서 객체를 삭제하는 것은 리스트와는 약간 다르게 동작
- 리스트에서는 입력 요소에 NULL을 설정하면 제거되는데 env는 NULL가 바인딩됨
- 바인딩을 제거하려면 `rm()`을 사용해야 함
~~~r
e <- new.env()

e$a <- 1
e$a <- NULL
ls(e)
#> [1] "a"

rm("a", envir = e)
ls(e)
#> character(0)
~~~
- `exists()`로 바인딩이 어떤 env에 존재하는지 판단할 수 있음
- `get()`처럼 `exists()`의 기본 행동은 정규 스코핑 규칙을 따라 부모 env에서 찾는 것
- 이 행동을 원치 않으면 `inherits = FALSE`를 사용해라
~~~r
x <- 10
exists("x", envir = e)
#> [1] TRUE

exists("x", envir = e, inherits = FALSE)
#> [1] FALSE
~~~
- env들을 비교하려면 ==가 아니라 `identical()`을 사용해야 함
~~~r
identical(globalenv(), environment())
#> [1] TRUE

globalenv() ==  environment()
#> Error in globalenv() == environment() : 
#>  comparison (1) is possible only for atomic and list types
~~~

## 8.2 환경에서의 재귀
- env은 트리 구조를 구성하므로 <b>재귀 함수(recursive function)</b>를 작성하는 것이 편리함
- 이 절은 유용한 함수인 `pypr::where()`를 이해하기 위해 env에 대한 새로운 지식을 적용하는 방법을 소개함
- 이름이 주어지면, `where()`는 R의 정규 스코핑 규칙을 사용하여 그 이름이 정의된 env를 찾음
~~~r
library(pryr)
x <- 5
where("x")
#> <environment: R_GlobalEnv>

where("mean")
#> <environment: base>
~~~
- `where()`의 정의는 간단. 이 함수는 두 개의 인자를 가지고 있는데, 하나는 탐색할 이름(문자열)이고, 다른 하나는 검색을 시작할 env
~~~r
where <- function(name, env = parent.frame()){
  if(identical(env, emptyenv())){
    stop(" Can't find ", name, call. = FALSE)
  }else if(exists(name, envir = env, inherits = FALSE)){
    # 성공한 경우
    env
  }else{
    # 재귀적인 경우
    where(name, parent.frame(env))
  }
}
~~~
- 재귀적으로 env 작업을 하는 것이 자연스러우므로 `where()`는 유용한 탬플릿을 제공
- `where()`의 특이 사항들을 제거하면 그 구조를 보다 명백하게 볼 수 있음 
~~~r
f <- function(..., env = parent.frame()){
  if (identical(env, emptyenv())){
    # 기본적인 경우
  }else if(success ){
    # 성공한 경우
  }else{
    # 재귀적인 경우
    f(name, parent.frame(env))
  }
}
~~~

## 8.3 함수 환경(function env)
- 대부분의 env는 `new.env()`에 의해서가 아니라 함수 사용의 결과물로 생성
- 이 절에서는 함수와 관련된 네 가지 유형, <b>엔클로징, 바인딩, 함수실행, 함수호출 env을 알아봄</b>
- 엔클로징(enclosing) env는 함수가 생성된 env임. <b>모든 함수는 하나의 유일한 엔클로징 env를</b> 가짐
- 세 가지 다른 유형의 환경인 경우 0, 1, 또는 각 함수에 연관된 많은 env들이 있음
  - <- 로 이름에 함수를 바인딩 하는 것은 바인딩 env를 정의함
  - 함수 호출은 함수 실행 중 생성된 변수를 저장하는 일시적 실행 env을 생성
  - 모든 실행 env는 호출 env와 연관되어 있는데, 이 env는 함수가 어디에서 호출되어는지 알려줌

### 8.3.1 엔클로징 환경
- 함수가 생성될 때 함수는 만들어진 env에 대한 참조를 가지게 됨
- 이 env를 <b>enclosing env</b>라고 하며, 렉시칼 스코핑에 사용됨
- 함수의 엔클로징 env는 함수를 그 첫번째 인자로 하는 `environment()`를 호출하여 알 수 있음
~~~r
y <- 1
f <- function(x) x + y
enviroment(f)
#> <environment: R_GlobalEnv>
~~~

### 8.3.2 바인딩 환경
- 앞의 f 함수는 변수를 따로 가지고 있지 않기 때문에 지나치게 단순함
- 대신 함수의 이름 자체가 바인딩에 의해 정의됨
- 함수의 바인딩 env는 그 함수에 바인딩을 가지는 모든 env임
- 위의 경우는 인클로징 env와 바인딩 env는 동일
- 함수를 다른 env에 할당하면 두 env가 달라짐(다음 예제)
~~~r
e <- new.env()
e$g <- function() 1
~~~
- 엔클로징 env는 함수에 속하고, 그 함수가 다른 env로 이동하더라도 절대 바뀌지 않음
- 엔클로징 env는 함수가 값을 찾는 방법을 정의하는데(렉시칼 스코핑에 의해) 바인딩 환경은 사용자가 함수를 찾는 방법을 결정
- 바인딩 환경과 엔클로징 환경을 구분하는 것은 <b>패키지 네임스페이스(namespaces)</b>에 중요
- 패키지 네임스페이스는 패키지를 독립적인 상태로 유지
- 예를 들어 패키지 A가 베이스 `mean()` 함수를 사용할 때 패키지 B가 고유의 mean() 함수를 생성한다면 어떤 일이 발생할까? 
- 이 때 네임스페이스는 패키지 A가 베이스 `mean()` 함수를 계속 사용하도록 보장하고, 패키지 A가 패키지 B에 확실하게 영향을 받지 않도록 함
- 네임스페이스는 함수가 엔클로징 env에 상주할 필요가 없다는 이점을 가지면서 환경을 사용하여 구현
- 예를 들어 `sd()`를 살펴보자. 이것의 바인딩과 엔클로징 환경은 다름
~~~r
environment(sd)
#> <environment: namespace:stats>

where("sd")
#> <environment: package:stats>
~~~
- `sd()`의 정의는 `var()`를 사용하지만, 자신만의 `var()`를 만들어도 `sd()`에 영향을 미치지 않음
~~~r
x <- 1:10
sd(x)
#> [1] 3.02765

var <- function(x, na.rm = T) 100
sd(x)
#> [1] 3.02765 
~~~
- 이 모든 패키지가 package env와 namespace env 를 갖고 있기 때문에 동작
- package env는 공개적으로 접근할 수 있는 모든 함수를 포함하고 있으며, 검색 경로상에 위치
- namespace env는 모든 함수를 포함하고, 이것들의 부모 env는 패키지가 필요로 하는 모든 함수에 대한 바인딩을 포함하는 특별한 import env
- 패키지에서 내보내진 모든 함수는 package 환경에 바인딩 되어 있지만, namespace env에 의해 엔클로징 됨
- 콘솔에 `var()`를 입력할 때 처음에 전역 env에서 찾아감. `sd()`가 `var()`를 찾을 때  
  namespace env에서 먼저 찾으므로 `globalenv()`에서는 절대 찾지 않음

### 8.3.3 실행 환경
- 다음의 함수를 처음 실행했을 때 무엇을 반환하는가? 두 번째로 실행할 때는 무엇을 반환하는가? 
~~~r
g <- function(x){
  if (!exists("a", inherits = FALSE)){
    message("Defining a")
    a <- 1
  }else{
    a <- a + 1
  }
  a
}
g(10)
g(10)
~~~
- 이 함수는 6.2.3절의 fresh start principles 때문에 항상 호출될 때 마다 매번 동일한 결과를 반환
- 함수가 호출될 때마다 호스트 실행을 위한 새로운 환경이 매번 생성됨
- <b>실행 env(execution environment)의 부모는 그 함수의 엔클로징 env</b>
- 함수가 한 번 완료되면 이 환경은 사라짐
- 보다 쉬운 함수로 이 환경을 시각적으로 설명해 보았음
- 그 함수가 속한 실행 환경을 함수의 주변 점선 테두리로 표시함
~~~
h <- function(x) {
  a <- 2
  x + a
}
y <- h(1)
~~~
![img]()
![img]()
- 어떤 함수를 다른 함수 내부에 생성할 때 자식 함수의 엔클로징 env는 부모의 실행 env이고, 이 실행 env는 더 이상 즉시 소멸하지 않음
- 다음 사례는 function factory인 `plus()`로 이 아이디어를 설명하고 있음
- `plus_one()`이라는 함수를 생성하기 위해 이 factory를 사용
- `plus_one()`의 엔클로징 env는 x가 값 1로 바인딩된 `plus()`의 실행 env
~~~r
plus <- function(x){
  function(y) x + y
}
plus_one <- plus(1)
identical(parent.env(environment(plus_one)), environment(plus))
#> [1] TRUE
~~~

### 8.3.4 호출 환경
- 아래의 코드를 살펴보자. 코드가 실행되었을 때 `i()`가 무엇을 반환할 것이라고 예상하는가? 
~~~r
h <- function(){
  x <- 10
  function(){
    x
  }
}
i <- h()
x <- 20
i()
~~~
- `x <- 20` 이라는 구분은 낚시임
- 즉 정규 스코핑(렉시칼 스코핑)을 규칙을 사용하는 `h()`는 우선 정의된 곳에서 x를 찾은 후 연관된 값인 10을 찾음
- 그러나 `i()`가 호출된 환경에서 x가 어떤 값과 연관되어 있는지를 질문하는 것은 여전히 의미가 있음
- 즉 x가 `h()` 가 정의된 환경에서는 10이지만, 호출된 환경에서는 20
- 호출된 환경은 `parent.frame()`을 이용하여 접근할 수 있음
- 이 함수는 함수가 호출된 env을 반환
- 이 함수를 그 환경에서 이름의 값을 찾는 데 사용할 수도 있음
~~~r
f2 <- function(){
  x <- 10
  function(){
    def <- get("x", environment())
    cll <- get("x", parent.frame())
    list(defined = def, called = cll)
  }
}
g2 <- f2()
x  <- 20
str(g2())

#> List of 2
#>  $ defined: num 10
#>  $ called : num 20
~~~ 
- 보다 복잡한 상황을 가정하면 단지 하나만의 부모 호출이 아니라 최상위 레벨에서 호출된 초기 함수로 되돌아가는 모든 방법을 유도하는 <b>호출 시퀀스(sequence of calls)</b>가 있음
- 다음 코드는 세 단계 깊이의 호출 스택(call stack)을 생성
~~~r
x <- 0
y <- 10
f <- function(){
  x <- 1
  g()
}
g <- function(){
  x <- 2
  h()
}
h <- function(){
  x <- 3
  x + y
}
f()
~~~
- 엔클로징 env 뿐만 아니라 호출 env에서 변수를 찾는 것을 <b>동적 스코핑(dynamic scoping)</b>이라고 함
- 동적 스코핑은 함수가 동작하는 방법을 이해하기 훨씬 어려움
- 함수가 정의되는 방법도 알아야하고, 함수가 호출되는 배경도 알아야 함 

## 8.4 값에 이름을 바인딩하기
- 할당(assignment)는 어떤 env에서 값에 이름을 바인딩하거나 <b>리바인딩</b>하는 행동
- 이것은 스코핑에 대응되는 것으로, 특정 이름과 연관된 값을 찾는 방법을 결정하는 규칙들의 집합
- 많은 언어들과 비교했을 때, R은 값에 이름을 바인딩하는데 극도로 유연한 도구를 갖고 있음
- 사실, 값만 이름에 바인딩하는 것이 아니라 표현식(프로미스)이나 함수조차 바인딩 할 수 있기 때문에 매번 이름과 연관된 값에 접근할 때 마다 어떤 다른 값을 얻음
- R에서 수천 번 정규 할당을 사용했을텐데, 정규 할당은 현재 환경에서 이름(변수)과 객체 사이의 바인딩을 생성
- 이름(변수)은 일반적으로 글자, 숫자, ., _로 구성되고 _로 시작되지 못함 
- 이 규칙을 따르지 않는 이름을 사용하려고 하면, 다음과 같은 오류 발생
~~~r
_abc <- 1
#> Error: unexpected input in "_"
~~~
- 예약어(reserved words, ex) if, TRUE 등)는 해당 규칙을 따르지만 다른 목적으로 이미 사용되고 있음
~~~r
if <- 10
#> Error: unexpected assignment in "if <-"
~~~
- 예약어 전체 목록은 ?Reserved로 찾을 수 있음
- 일반 규칙을 무시할 수 있는데 역따옴표(백틱)로 감싼 문자 시퀀스로 된 이름을 사용하는것
~~~r
`a + b` <- 3
`:)` <- "smile"
`   ` <- "spaces"
ls()
#> [1] "   "   ":)"    "a + b" "e"     "f"
~~~
- <b>정규적으로 사용되는 할당 화살표(<-)는 항상 현재 환경에서 변수를 생성</b>
- <b>깊은 할당(deep assignment, <<-)은 절대로 현재 환경에서 변수를 생성하지 않고, 부모 환경까지 올라가서 찾아진 기존의 변수를 수정</b>
~~~r
x <- 0
test <- function(){
  x <<- 1
  }
test()
x
#> [1] 1  
~~~
- <<- 가 기존의 변수를 찾지 못하면 이 깊은 할당 연산자는 전역 env에서 변수 하나를 만듬
- 이런 현상이 기본적으로 바람직하지 못한 이유는 전역 변수가 함수 간에 명확하지 않은 의존성을 나타내기 때문
- <<- 는 클로저와 같이 가장 흔히 혼용됨
- 바인딩에는 지연(delayed)와 활성(active)이라는 두 가지 특별한 유형이 존재

#### 지연된 바인딩(delayed binding)
- 표현식의 결과를 즉시 할당하기보다 필요할 때 그 표현식을 평가하기 위한 프로미스를 생성하고 저장
- 지연된 바인딩은 pryr 패키지에서 제공하는 `%<d-%` 라는 특수 할당 연산자로 생성할 수 있음
~~~r
library(pryr)
system.time(b %<d-% {Sys.sleep(1); 1})
#>   사용자  시스템 elapsed 
#>      0       0       0 

system.time(b)
#>  사용자  시스템 elapsed 
#>   0.00    0.00    1.06 
~~~
- `%<d-%`는 베이스 함수인 `delayedAssign()` 래퍼인데, 더 많은 제어가 필요할 때 이 연산자를 직접 사용해야 할 수도 있음
- 지연된 바인딩은 `autoload()`를 구현하는 데 사용됨
- 이 함수는 오로지 사용자가 요청했을 때 디스크로부터 로드됨에도 불구하고 R이 마치 패키지 데이터가 메모리에 있는 것과 같이 동작하게 함

#### 활성 바인딩(active binding)
- 활성(active)는 고정된 객체(constant object)에 바인딩되지 않음
- 대신 접근할 때마다 매번 재계산
~~~r
x %<a-% runif(1)
x
#> [1] 0.110141

x
#> [1] 0.1063044
rm(x)
~~~
- `%<a-%`는 베이스 함수인 `makeActiveBinding()`의 래퍼
- 보다 많은 제어를 원하면 이 함수를 직접 사용해야 함
- 활성 바인딩은 참조 클래스 필드를 구현하는 데 사용

## 8.5 명시적 환경
- env은 스코핑을 보다 강력하게 해 줄 뿐만 아니라 그 스스로 유용한 데이터 구조임
- 왜냐하면 이 env들이 참조 시맨틱스를 가지기 때문
- 참조 시맨틱스를 가진다는 것은 R 객체와 달리 env의 수정을 가할 때는 사본을 만들지 않는다는 의미
- `modify()`를 살펴보자
~~~r
modify <- function(x){
  x$a <- 2
  invisible()
}
~~~
- 리스트 객체에 이 함수를 적용하면 리스트를 수정하는 것이 실제로는 사본을 생성하고 수정하는 것이기 때문에 원래의 리스트는 수정되지 않음
~~~r
x_l   <- list()
x_l$a <- 1
modify(x_l)
x_l$a
#> [1] 1
~~~
- 만약 해당 함수에 env를 인자로 넣으면 기존 env가 수정됨
~~~r
x_e <- new.env()
x_e <- 1
modify(x_e)
x_e$a
#> [1] 2
~~~
- 함수 간 데이터 전달을 위해 리스트를 사용할 수 있는 것처럼 env도 사용할 수 있음
- 고유의 env를 생성할 때 그 env의 부모 env를 empty env가 되도록 설정해야 한다는 점에 주의
- 이것은 확실히 다른 어떤 곳의 객체를 우연히 상속하지 않도록 함
~~~r
#- 부모 env를 empty env로 설정하지 않았을 때,
x <- 1
e1 <- new.env()
get("x", envir = e1)
#> [1] 1

e2 <- new.env(parent = emptyenv())
get("x", envir = e2)
#> Error in get("x", envir = e2) : object 'x' not found
~~~
- <b>env는 다음의 공통적인 세 가지 문제를 해결하는 데 유용한 데이터 구조</b>
  - 큰 데이터의 복제를 회피
  - 패키지 내에서 상태를 관리
  - 이름에서 값을 효율적으로 검색

### 8.5.1 사본 회피 
- 과거(R 3.1.0)은 리스트를 수정할 때마다 deep copy가 이루어졌음
- 그래서 연산이 많이 소요되었는데, 요즘은 deep copy가 일어나지 않고 기존의 벡터를 재사용하여 시간을 많이 절약

### 8.5.2 패키지 상태
- 명시적 환경이 패키지에 유용한 이유는 사용자가 함수 호출 간 상태를 유지할 수 있게 해 주기 때문
- 일반적으로 패키지 내의 객체는 잠겨 있으므로 그 객체를 직접 수정하지 못함. 대신 다음과 같이 할 수 있음
~~~r
my_env <- new.env(parent = emptyenv())
my_env$a <- 1

get_a <- function(){
  my_env
}

set_a <- function(value){
  old      <- my_env$a
  my_env$a <- value
  invisible(old) 
}
~~~
- 설정자 함수(setter function)으로부터 이전 값을 반환하는 것은 바람직함 패턴
- 왜냐하면 `on.exit()`와 혼용하는 경우 이전의 값을 다시 설정하기 쉽게 해 주기 때문

### 8.5.3 해시맵으로 사용
- 해시맵(hashmap)은 그 이름에 기초하여 객체를 찾기 위해서 O(i)의 고정된 시간을 갖는 데이터구조
- env는 기본적으로 이런 행동을 제공하므로 해시맵을 시뮬레이션 할 수 있음



## 용어 정리
- 참조 시멘틱스(reference semantics)
  - 쉽게 말하면, 내가 쓰고 있는 타입들이 reference로서 의미가 있는 것을 말함
  - 참조 시멘틱스와 대립되는 시멘틱스는 value semantics 임 
  - 일반적으로 함수형 프로그래밍 언어들은 value semantics에 좀 더 초점을 두고 있음

- 바인딩(binding)
  - 프로그램의 어떤 기본 단위가 가질 수 있는 구성요소의 구체적인 값

- 네임스페이스(namespace)
  - 객체를 구분할 수 있는 범위를 나타내는 말로, 하나의 네임스페이스에서는 하나의 이름이 단 하나의 객체만을 가리키게 됨
  - C++나 Java에서는 네임스페이스를 명시적으로 지정해 사용 가능