## chapter08 환경
### 8.1 environment 기초

* environment은 list, atomic vector와 같이 하나의 객체로서 생각할 수 있음
* environment의 역할은 값에 이름을 연결 또는 바인딩하기 위한 것
* environment은 이름 주머니라고 생각 할 수 있음
* 각 이름은 메모리 어딘가에 저장되어 있는 객체
~~~
e   <- new.env()
e$a <- FALSE
e$b <- "a"
e$c <- 2.3
e$d <- 1:3
~~~
* 여러개의 객체는 동일한 객체를 바라볼 수 있음
~~~
e$a <- e$d # a, d 둘다 1:3 이라는 값을 참조하는 이름.
~~~
* environment은 같은 값을 가진 다른 객체를 가리킬 수 있음
~~~
e$a <- 1:3 # a와 d는 1:3 이라는 같은 값을 가지는 다른 객체
~~~
* 객체가 이름을 갖고 있지 않으면 자동으로 garbage collector에 의해 삭제됨
* 모든 environment은 부모로 다른 환경을 가짐
* 어떤 이름이 특정 environment에서 발견되지 않으면 R은 그것의 부모를 찾고, 이런 작업을 반복함
* 공환경(empty environment)만 부모를 가지지 않음
* 일반적으로 4가지만 제외하면 환경은 리스트와 유사
  * environment의 모든 객체는 유일한 이름을 가짐
  * environment 내에 객체는 순서가 없음(어떤 환경에서 처음 객체가 무엇인지 찾는 것은 의미가 없음)
  * environment은 부모를 가짐
  * environment은 참조 시맨틱스를 가짐  
* environment은 두 가지 요소로 구성되어 있음
  * 이름-객체 바인딩을 포함하고 있는 frame
  * 부모 환경
* 네 가지 특수한 environment 존재
  * <b/> globalenv() </b> 또는 전역 environment.  
    이 환경은 일반적인 작업 환경. 전역 환경의 부모는 library() 또는 require()로 붙인 마지막 패키지
  * <b/> baseenv() </b> 또는 베이스 environment.  
    base 패키지의 환경. 그 부모는 공환경임
  * <b/> emptyenv() </b> 또는 공 환경.  
   모든 환경의 궁극적인 조상. 부모가 없는 유일한 환경
  * <b/> environment() </b> 현재의 environment.

* search()는 전역 environment의 모든 부모를 열거
* as.environment()를 사용하면 검색 목록에 관한 환경에 접근할 수 있음
~~~
search()
as.environment("package::stats")
~~~
* globalenv() -> baseenv() -> emptyenv()로 연결되어 있음(-> 부모/조상 환경)
* environment을 직접 생성하려면 new.env()를 사용
* ls()는 해당 환경의 frame에서 바인딩을 확인 할 수 있고, parent.env()로 그 부모를 확인 할 수 있음
~~~
e <- new.env()
parent.env(e) # 전역 environment이 나옴
ls(e)         # ls()는 해당 environment의 frame에서 바인딩을 확인
~~~

* environment 에서 바인딩을 수정하는 가장 쉬운 방법은 리스트처럼 수정하는 것
~~~
e$a <- 1
e$b <- 2
ls(e)
e$a
~~~
* ls()는 dot(.)으로 시작하는 이름은 보여주지 않음.   
어떤 environment의 모든 바인딩을 보려면 all.names = TRUE를 사용하자
~~~
e$.a <- 2
ls(e)
ls(e, all.names = TRUE)
~~~
* ls.str()를 이용해서도 환경 확인 가능. 이는 환경 내의 각 객체를 보여 주기 때문
~~~
str(e)
ls.str(e)
~~~
* 리스트처럼 $, [[, get()으로 바인딩되어 있는 값을 추출 가능
* environment에서 바인딩을 제거하려면 rm()을 사용
~~~
e <- new.env()
e$a <- 1
e$a <- NULL
ls(e)

rm("a", envir = e)
ls(e)
~~~
* exists()로 바인딩이 어떤 environment에 존재하는지 판단할 수 있음  
exists의 기본 행동은 부모 environment에서 찾는 것. 원하지 않으면 inherits = FALSE 이용
~~~
x <- 10
exists("x", envir = e)
exists("x", envir = e, inherits = FALSE)
~~~
* environment을 비교하려면 == 가 아닌, identical를 이용
~~~
identical(globalenv(), environment())
~~~
### 8.3 함수 environment
* 대부분의 environment은 new.env()에 의해서가 아니라 함수 사용의 결과물로 생성
* 함수와 관련된 4가지 유형, 엔클로징, 바인딩, 실행, 호출 environment을 살펴보자

##### 엔클로징(enclosing)
* 함수가 생성된 environment
* 모든 함수는 하나의 엔클로징 environment를 가짐
* 세가지 다른 유형의 함수인 경우, 0, 1 또는 각 함수에 연관된 많은 함수가 있음
  * <- 로 함수를 바인딩 하는 것은 바인딩 environment을 정의
  * 함수 호출은 실행 중 생성된 변수를 저장하는 일시적 실행 environmenㄱㄹ t을 생성
  * 모든 실행 environment은 호출 환경과 연관되어 있는데, 이 environment은 함수가 어디에서 호출되었는지 알려줌

#### 8.3.1 엔클로징 환경
* 함수가 생성될 때 함수가 만들어진 환경을 말함
* 렉시칼 스코핑에 사용됨
* 엔클로징 환경은 environment() 함수에 첫번째 인자로 할당하여 확인 가능
~~~
y <- 1
f <- function(x) x + y
environment(f) # 함수가 만들어진 환경은 global env!
~~~

#### 8.3.2 바인딩 환경
* 바인딩 환경은 그 함수에 바인딩을 가지는 모든 환경을 말함
* 위의 예제는 y 바인딩의 환경과 f 함수의 환경 자체가 동일 함
* 다음 예제와 같이 함수를 다른 환경에 할당하면, 두 환경이 달라지게 됨
~~~
 e <- new.env()
 e$g <- function() 1
~~~
* 바인딩 환경과 엔클로징 환경을 구분하는 것은 패키지 네임스페이스에 중요
* 패키지 네임 스페이스는 패키지를 독립적인 상태로 유지
* A package가 고유의 mean 함수를 사용하고, B package가 독립적인 고유의 mean 함수를 사용할 때
-> 서로 영향 받지 않도록 함

* sd() 예시
  * 해당 함수의 엔클로징 환경과 바인딩 환경은 다름
~~~
environment(sd)
where("sd")
~~~
* sd 함수 내부적으로 var 함수를 사용하는데, 자신만의 var를 만들어도 sd 함수에 영향을 미치지 않음
~~~
x <- 1:10
sd(x)
var <- function(x, na.rm = TRUE) 100
sd(x)
~~~
* 패키지는 두 가지 환경, package 환경과 namespace 환경을 갖고 있기 때문에 동작
  * package 환경 : 사용자가 접근할 수 있는 함수를 포함하고 있으며, 검색 경로에 위치
  * namespace 환경 : 사용자 접근 함수를 포함한 패키지가 필요로 하는 모든 함수를 포함하는 특별한 import 환경
* <b/>패키지에서 내보내진 모든 함수는 package 환경에 바인딩 되어 있지만, namespace 환경에 의해 엔클로징됨 </b>
* 따라서 sd 함수는 namespace 환경에서 우선적으로 var를 찾으므로, globalenv에 백날 var 함수를 선언해도 참조하지 않음

#### 8.3.3 실행 환경
* 다음의 예제는 어떤 값을 return?
~~~
g <- function(x) {
  if (!exists("a", inherits = FALSE)){
    message("Defining a")
    a <- 1
  }else{
    a <- a + 1
  }
}
g(10)
g(10)
~~~
* 결과적으로 호출할 때마다 동일한 결과 값을 return 한다
* 함수가 호출될 때 마다 호스트 실행을 위한 새로운 환경이 생성됨
* 실행 환경의 부모는 그 함수의 엔클로징 환경. 함수가 한 번 완료되면 이 환경은 사라짐
* 어떤 함수가 함수 내부에서 생성될 때, 자식 함수의 엔클로징 환경은 부모의 실행 환경(함수)이고, 소멸되지 않음
* 다음 예제에서 plus_one의 엔클로징 환경은 x가 1로 바인딩된 plus의 실행 환경
~~~
'# function factory 예제
plus <- function(x) {
  function(y) x + y
}

plus_one <- plus(1)
identical(parent.env(environment(plus_one)), environment(plus)) # TRUE
~~~

#### 8.3.4 호출 환경
* 다음 결과 값은 어떤 값을 return 할까?
~~~
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
* 결과적으로는 10을 리턴
* 정규 스코핑 규칙을 사용하여 정의된 환경의 10을 참조
* x가 h()가 정의된 환경에서는 10이지만, h() 호출된 환경에서는 20임

* 호출된 환경은 parent.frame()를 이용하여 접근할 수 있음. 이 환경은 호출된 환경을 반환
~~~
f2 <- function(){
  x <- 10
  function() {
    def <- get("x", environment())
    cll <- get("x", parent.frame())
    list(defined = def, called = cll)
  }
}

g2 <- f2()
x  <- 20
str(g2())

List of 2
$ defined: num 10
$ called : num 20
~~~

* sequence of calls : 단지 하나만의 부모 호출이 아닌 최상위 레벨에서 호출된 초기 함수로 되돌아가는 모든 방법을 유도하는 것
* 다음 코드는 세 단계 깊이의 call stack 생성
~~~
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

f() # 13
~~~
* R의 스코핑 규칙은 엔클로징 부모만 사용한다는 것
* 엔클로징 환경이 아닌 호출 환경에서 변수를 찾는 것을 동적 스코핑(dynamic scoping)이라고 함
* 동적 스코핑을 적용한 언어는 많지 않음. why? 이해하기가 훨씬 어렵기 때문
* 또한 함수가 정의되는 방법도 알아야하고, 호출되는 배경도 알아야 함

## 8.4 값에 이름을 바인딩하기
* 할당(assignment)는 어떤 환경에서 값에 이름을 바인딩하거나, 리바인딩 하는 행동
* 특정 이름과 연관된 값을 찾는 방법을 결정하는 규칙들의 집합
* R은 이름을 바인딩하는데 굉장히 유연한 도구들을 가지고 있음
* 값 뿐만 아니라 표현식(promise)나 함수도 바인딩 할 수 있음
* 먼저 우리가 잘아는 정규 할당(regular assignment)이 있음
~~~
abc <- 10
~~~
* 깊은 할당(deep assignment, <<-)는 <b/>현재의 환경에서 변수를 생성하지 않고</b> 부모 환경까지 올라가서 찾아진 기존의 변수를 수정
~~~
x <- 0
f <- function(){
  x <<- 1
}
f()
x

[1] 1
~~~
* <<- 가 좋지 않은 이유는 전역 변수가 함수 간의 명확하지 않은 의존성을 나타내기 때문

* 바인딩에는 지연(delayed)와 활성(active)이라는 두 가지 특별한 유형이 있음
* 지연된 바인딩은 표현식의 결과를 즉시 할당하기 보다 표현식이 실행될 때 수행됨
~~~
library(pryr)
system.time(b %<d-% {Sys.sleep(10); 1} )

사용자  시스템 elapsed
0       0       0
system.time(b)

사용자  시스템 elapsed
0.00    0.00   10.06
~~~
* 활성(active)는 constant object에 바인딩되지 않음. 대신 매번 접근할 때마다 재계산
~~~
x %<a-% runif(1)
x
x
rm(x)
~~~

### 8.5 명시적 환경
* 환경은 reference semantics를 가짐
* 즉 R 객체와 달리 환경에 수정을 가할 때는 복사본이 생기는 것이 아니라 값 자체가 수정됨
* 다음의 예제를 살펴보자
* 리스트에 modify 함수를 적용하면, 기존 객체는 수정되지 않는다
~~~
modify <- function(x){
  x$a <- 2
  invisible()
}

x_l   <- list()
x_l$a <- 1
modify(x_l)
x_l$a

[1] 1
~~~

* <b/>만약 modify 함수를 환경에 적용하면 기존 객체가 수정된다</b>
~~~
x_e <- new.env()
x_e$a <- 1
modify(x_e)
x_e$a

[1] 2
~~~
* 함수 간 데이터 전달을 위해 리스트를 사용할 수 있는 것처럼 환경도 사용 가능
* 고유의 환경을 생성 할 때 그 환경의 부모 환경을 공환경이 되도록 설정해야 함
~~~
x  <- 1
e1 <- new.env()
get("x", envir = e1)

e2 <- new.env(parent = emptyenv()) # 다음과 같이 부모 환경이 공환경이 되도록 설정
get("x", envir = e2)
~~~
* 환경은 다음 3가지 문제를 해결하는데 유용한 데이터 구조
  * 큰 데이터의 복제를 회피
  * 패키지 내에서 상태를 관리
  * 이름에서 값을 효율적으로 검색

#### 8.5.1 사본 회피
* 큰 객체에 유용하게 사용
* 최근에는 리스트를 수정하는 경우 사본이 생성되지 않으므로, 유용성이 떨어짐
* R 3.1.0 의 변화에서 생김

#### 8.5.2 패키지 상태
* 명시적 환경 사용시 사용자가 함수 호출 간 상태를 유지시켜 주므로 패키지에 유용
* 일반적으로 패키지 내의 객체는 잠겨있으므로 수정이 불가능.. 대신 다음과 같이 할 수 있음
~~~
my_env <- new.env(parent = emptyenv())
my_env$a <- 1

get_a <- function() {
  my_env$a
}

set_a <- function(value) {
  old      <- my_env$a
  my_env$a <- value
  invisible(old)
}
~~~

## 용어 정리
##### 바인딩
* 프로그램의 기본 단위에 해당 기본 단위가 가질 수 있는 속성 중에서 일부 필요한 속성들만 선택하여 연결시켜 주는 것을 말함
* 변수로 예를 들면, 변수를 구성하는 식별자(이름), 자료형 속성, 하나 이상의 주소(참조), 자료값에 구체적인 값으로 확정하는 것을 말함

##### 렉시칼 스코핑
* scope는 함수를 호출할 때가 아닌 선언할 때 생성된다는 의미를 지칭함

##### 네임 스페이스
* 객체를 구분할 수 있는 범위를 나타내는 말
* 일반적으로 하나의 네임 스페이스는 하나의 이름이 하나의 객체만을 가리키게 됨

##### 참조 시멘틱스(reference semantics)
* 우리가 보통 말하는 call by reference에서의 reference를 말함
* R 객체와 달리 참조 시멘틱스를 가지는 environment는 수정을 가할 때 복사본을 만들지 않음

## 연습 문제
#### 8.3.5
1. 함수와 관련된 4가지 환경을 나열하라. 각각은 무슨 역할을 하는가? 엔클로징 환경과 바인딩 환경의 구분이 특별히 중요한 이유는 무엇인가?
2. 다음 함수의 엔클로징 환경을 보여 주는 그림을 그려 보라
~~~
f1 <- function(x1){
  f2 <- function(x2){
    f3 <- function(x3){
      x1 + x2 + x3
    }
    f3(3)
  }
  f2(2)
}
f1(1)
~~~
3. 함수 바인딩을 보여 주도록 앞의 그림을 확장하라
4. 실행 환경과 호출 환경을 보이도록 다시 한 번 그림을 확장하라
5. 함수에 대한 더 많은 정보를 제공하는 강화된 버전의 str()을 작성하라. 이 함수를 어디서 찾을 수 있고, 어느 환경에서 정의되었는지를 보여라
