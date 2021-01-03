# chapter06_function
# -> 함수에 대해서 완벽 타파!
# 2019_06_28
# findGlobals, force, missing, do.call, exists, par, invisible, Filter


# ** 함수 : function
# R을 이해하는데 가장 중요한 점은 함수 그 자체가 객체라는 점
# body()    : 함수 안에 쓰인 코드
# formals() : 함수 호출을 제어하는 인자 목록
# environment() : 함수의 변수에 대한 위치 지도
# -> 함수를 출력 시켰을 때, 함수에 대한 environment가 안나오는 경우는, 함수가 global environment 일 때 나오지 않음 

f <- function(x) x^2

formals(f)     # 함수를 제어하는 인자를 표기
body(f)        # 함수 내에 쓰인 body 내용
environment(f) # 환경

f # -> 해당 함수에 대한 environment 가 나오지 않음

# 해당 함수들은 할당 연산자를 통해 수정도 가능!

# * R의 모든 객체들처럼, 함수도 attributes()로 임의의 추가 속성을 가질 수 있음
# srcref -> 함수를 만드는데 사용된 소스코드를 가리킴. 이속성은 body와는 다르게 코드 주석과 기타의 형식 등을 담고 있음
# 함수에는 추가적으로 속성을 부여할 수 있음. 예를 들어, class()를 설정하고 개인화된 print 메소드를 추가할 수 있음

attributes(f)

# ** 원시 함수(primitive functions)
# 3가지 요소를 가진다는 규칙에는 한가지 예외가 있는데, 원시 함수에 해당
# 다음과 같은 윈시 함수는 Primitive()로 직접 C 코드를 호출하는데, 이 함수는 R 코드가 없음
# 따라서 3가지 요소가 모두 NULL 임

# 원시 함수 -> sum

sum
formals(sum)
body(sum)
environment(sum)

# 원시 함수는 base 패키지에서만 찾을 수 있음
# 기본적으로 이런 base 함수는 따로 생성하지 않음. -> R의 다른 함수와 다르게 움직이는 부정적인 효과가 있기 때문

# 6.1.2 연습문제 ----
# 1. 객체의 함수 여부를 알려주는 함수? 원시 함수 여부를 알려주는 함수?
# -> is.function(), -> is.primitive()
is.function(f)
is.primitive(sum)

# 2. 다음 코드는 base 패키지 내의 모든 함수 목록을 만듬
objs <- mget(ls("package:base"), inherits = TRUE)
funs <- Filter(is.function, objs)


# 2.a base 함수 중 어느 것이 가장 많은 인자를 가지는가?
objs <- mget(ls("package:base"), inherits = TRUE)
funs <- Filter(is.function, objs)

# formals function은 기본적으로 base 내에 있는 primitives function 에서는 NULL 로 return
t.funs <- sapply(funs, function(x) length(formals(x)))
t.funs[order(t.funs, decreasing = T)][1] # scan -> 22개의 param 을 가지고 있음

# 2.b base 함수 중 인자가 없는 것은 얼마나 되는가? 그러한 함수는 어떤 점이 특별한가?
# -> 인자가 없는 것은 primitive function
# is.primitive() 로 확인 가능!

# 2.c 모든 원시 함수를 찾는 데 이 코드를 어떻게 적용할 수 있는가? 
Filter(is.primitive, funs)

# 3. 함수의 주요 구성 요소 3가지?
# -> body, formals, environments

# 6.2 렉시칼 스코핑 Lexical Scoping ----
# 렉시칼 스코핑이란, 스코프 자체는 함수를 호출할때가 아닌, 정의할 때 생긴다는 의미 
# 즉, 함수를 선언하는 순간, 함수 내부의 변수는 함수에서 가장 가까운 지역을 탐색하면서 선언된 변수를 확인


# 1. name masking
# 다음 사례는 lexical scoping의 가장 기본적인 원칙을 설명.
# -> ** 함수 내에 정의되지 않은 변수를 사용한다면, 한 수준 위를 탐색.

f <- function(){
  x <- 1
  y <- 2
  c(x, y)
}

# 함수안에 함수를 사용한 경우도 마찬가지로 전역 환경까지 거치는 모든 지역을 탐색해서 변수를 찾는다.
x <- 1
h <- function() {
  y <- 2
  i <- function(){
    z <- 3
    c(x, y, z)
  }
  i()
}
h()

# 클로저와 랙시칼 스코핑 간의 상호작용
# 핵심은 j(1) 를 k 변수에 할당했을 때, k 변수를 실행시키면, 내부 function만 정보로 나온다. 
# 그런데, k()를 실행시키면, y 값까지 제대로 출력시키고 있음을 알 수 있음 
# How? -> k가 j의 정의된 환경을 유지하고 있고, 그 환경은 y의 값을 포함하고 있음

j <- function(x){
  y <- 2
  function() {
    c(x, y)
  }
}


k <- j(1)
k()
rm(k, j)

# 2. functions vs variables
# 함수 검색은 변수를 찾는 방법과 동일하게 적용.
# 다음 예제는 전역 변수에 선언된 l 함수 전에, 지역 변수로 선언된 l 함수를 우선적으로 
# 인식한다는 예제. -> 역시 렉시칼 스코핑에 의한 접근! 

l <- function(x) x + 1 
m <- function() {
  l <- function(x) x * 2
  l(10)
}

m()
rm(l, m)

# 많이 사용되지는 않지만, 이름이 같은 함수인 것(객체)와 그렇지 않은 것이 있을때.
# n() 과 같이 명백하게 사용하면, 함수가 아닌 객체들을 무시한다.
# 일반적으로 이런 경우를 피하는 것이 좋다(당연, 함수랑 변수랑 누가 같은 변수명을 쓰나..?)

n <- function(x) x/2
o <- function() {
  n <- 10
  n(n)
}
o()

# 3. a fresh start
# 함수의 실행은 완벽하게 독립적 -> 내부 값들은 계속 new start 한다!
# 다음의 예제를 통해, 계속 j 함수를 실행시켜도 결과 값은 1로 나오는 것을 확인할 수 있음

j <- function() {
  if(!exists("a")){
    a <- 1
  }else{
    a <- a + 1
  }
  print(a)
}
j()



# 4. dynamic search
#   ** R은 함수가 생성될 때가 아니라, 실행될 때 값을 탐색함
#   이는 함수가 실행될 때, 함수 외부의 값에 따라서 결과가 달라질 수 있음을 의미

# 함수가 실행될 때 값을 탐색한다는 점 ** 
#   변수의 값을 참조해야하는 위치는 함수가 선언될 때 
#   값 자체는 함수가 실행될 때! 를 의미한다 (헷갈리지 말자)

f <- function() x
x <- 15
f()

x <- 20
f()

# 전역 변수를 사용하는 함수가 있을 때, 어떤 변수가 전역 환경에서 정의되는지에 따라 
# 오류가 날수도, 안날수도 있음을 의미한다.
# 이런 문제를 발견하는 방법1 -> findGlobals() 사용.
# 해당 함수에 특정 함수를 넣으면 전역 변수를 참고하는 모든 dependency를 나열해줌

f <- function() x + 1
codetools::findGlobals(f) # +, x가 있음을 확인

# Tip ** empytyenv() function
# 특정 함수의 환경을 공환경으로 변경 -> 모든 변수들의 dependency를 제거
# -> 이렇게 되면 연산자까지 모두 사용 안됨.. -> 비추
# 어떻게 사용하는지만 알자

environment(f) <- emptyenv()

# 6.2.5 연습문제
# 1. 다음 코드는 무엇을 반환하는가? 그 이유는 무엇인가? 
# 세 종류의 c가 의미하는 것은 각각 무엇인가?
c <- 10
c(c = c)
# -> 첫번째 c : 객체 변수 
# -> 두번째 c: concetrate의 c, 세번째 c -> vector의 name c

# 2. R이 값을 찾는 방법 4가지
# name masking              -> 함수가 선언 될 때 해당 스코프를 확정
# functions vs variable     -> 함수랑 변수랑 접근 방법은 동일
# a fresh start             -> 함수의 실행은 완벽하게 독립적
# dynamic search            -> 값의 탐색은 함수가 실행될 때 찾음


# 6.3 모든 연산은 함수 호출 ----
# R의 계산에서 존재하는 모든 것은 객체이며, 발생하는 모든 것은 함수임을 인식하자

## -- R은 모든 연산이 함수 호출
# ex) +, for, if, while, [], $ 등 모든 연산자들이 함수! 

# '(따옴표)를 통해 이미 예약되거나 허용되지 않은 이름을 가진 함수를 참조할 수 있다.
x <- 10; y <- 5

# 1. + 연산자(다음 두 경우는 같다)
x + y
'+'(x,y)

# 2. for roop 연산자
for(i in 1:2) print(i)
'for'(i, 1:2, print(i))

# 3. if 제어 연산자
if(i == 1) print("yes!") else print("No!")
'if'(i == 1, print("yes!"), print("No."))

# 4. [] subsetting 연산자
x[3]
'['(x, 3)

# 이렇게 하면 특수 함수를 다시 정의 할 수 있지만.. 좋지 않은 생각
# but, 유용한 경우도 있긴 함. 
# ex) dplyr 패키지가 R 표현식을 SQL 표현식으로 변역할 수 있게 해주는 경우,

# R에서 일어나는 것이 모두 함수이므로, 다음과 같이 사용 가능
# 1. sapply 내에 + 연산자 이용하는 경우,
sapply(1:10, '+', 3)
sapply(1:10, "+", 3)
# -> 첫 번째 +는 함수 자체를 의미하고, 두번째는 +라는 문자열인데, apply 계열 함수는 문자열도 받을 수 있으므로,
#    둘 다 같은 결과 값을 return 함

# 2. list의 특정 인덱스 값 호출
x <- list(1:3, 4:9, 10:12)
sapply(x, "[", 2)
sapply(x, function(x) x[2])
# -> 다음의 결과 값은 같다. why? [ 도 함수이기 때문!

# 6.4 함수 인자 ----
# 형식 인자(formal arguments), 실질 인자(actual arguments)를 아는 것이 유용
# 실질 인자 : 호출 인자(calling arguments)라고도 하며, 함수를 호출 할 때 마다 변함
# 형식 인자 : 하나의 함수 속성을 의미

# 6.4.1 함수 호출 ----
# 함수를 호출 할 때 위치, 전체 이름 또는 부분 이름으로 인자를 특정할 수 있음
# 인자는 다음과 같은 순서로 찾는다. 
# 1. 정확한 이름으로,  -> 2. 접두어 매칭 -> 3. 위치

f <- function(abcdef, bcde1, bcde2){
  list(a = abcdef, b1 = bcde1, b2 = bcde2)
}

str(f(1, 2, 3)) # -> 위치로 찾아감
str(f(2, 3, abcdef = 1)) # 정확한 인자명을 사용했기 때문
str(f(2, 3, a = 1)) # 길이가 긴 인자명을 접두어만 가지고 찾을수도 있음
str(f(1, 3, b = 1)) # 불분명한 줄여쓰기는 동작하지 않음

# 이름 있는 인자는 이름 없는 인자 뒤에 매칭해야 함
# ex) 어떤 함수가 ...를 사용한다면, 전체 이름과 함께 ... 뒤에 나열된 인자만을 특정할 수 있음

# good example 
# 첫 번째 인자는 공통이므로 인자명을 쓰지 않고, 뒤에 오는 인자는 고정은 아니므로 인자명을 표기
mean(1:10)
mean(1:10, trim = 0.05)

# 좀 지나친 경우
# -> 궂이 안써도 될 일을 쓰는 경우, 그냥 1:10로만 써도 됨
mean(x = 1:10)

# 혼란스러운 경우
# 아무 인자명을 안쓰는경우.. 도대체 뭔가 뭔지 모름
mean(1:10, n = T)
mean(1:10, ,F)
mean(1:10, 0.05)

# 6.4.2 주어진 인자 목록에서 함수 호출 ----
# -> list로 만들어진 인자 목록 + 값을 특정 함수로 전달하고 싶을때 -> do.call function 사용
# do.call function 
# list를 입력받아 해당 함수로 return

args <- list(1:10, na.rm = T)
do.call(mean, list(1:10, na.rm = T))

# 6.4.3 기본값과 결측 인자 ----
# R의 함수 인자는 기본값을 가질 수 있음
f <- function(a = 1, b = 2){
  c(a, b)
}
f()

# 함수 인자의 기본 값이 다른 인자의 값으로 들어갈 수 있음.(신기)
g <- function(a = 1, b = a * 2){
  c(a, b)
}
g()

# 함수 인자는 함수에서 정의된 값으로도 정의될 수 있음
# but 함수의 내부 소스를 읽지 않으면 모르므로, 비추

h <- function(a = 1, b = d){
  d <- (a + 1) ^ 2
  c(a, b)
}
h()

# ** missing function을 사용하면, 인자의 사용 여부를 판단할 수 있음
# but missing을 사용하면, 해당 인자가 필수 있자인지, 아닌지 알기가 어려움
i <- function(a, b){
  c(missing(a), missing(b))
}
i()
i(a=1)
i(b=2)
i(a=1,b=2)

# 6.4.4 느슨한 평가 ----
# 왜 느슨한 평가라고 하는지는 모르겠지만, 뜻은 다음과 같다
# -> 기본적으로 R 함수 인자는 느슨하다. 인자가 실제 사용됐을 때 평가된다
#    즉, 함수에 인자를 선언하거나 보내지 않아도 해당 변수가 사용되지 전까지는 평가되지 않는다는 의미

f <- function(x){
  10
}
f(stop("This is an error!")) # 인자가 실행되지 않았기 때문에 error 발생 안 함
# 인자를 평가하고 싶을 때, force 
# 

f <- function(x){
  force(x)
  10
}
f(stop("This is an error !")) # force 함수에 의해, stop 구문이 실행됨

# 다음과 같이 사용 가능하다는 점 인지하자.
# add라는 함수 생성 -> lapply를 통해 10개의 같은 함수 편성한 adders list 생성
# 해당 list

add <- function(x){
  function(y) x + y
}

adders <- lapply(1:10, add)
adders[[1]](10)
adders[[10]](10)

# 다음이 더 정확한 코드.
# -> force function을 이용하여 적용
add <- function(x) {
  force(x)
  function(y) x + y
}

adders2 <- lapply(1:10, add)
adders2[[1]](10)
adders2[[10]](10)

# ** 기본인자는 함수 내에서 평가됨
#    -> 표현식이 현재 환경에 의존되어 있다면, 
#       그 결과가 기본 값을 사용하는지, 값을 할당하는지에 따라 달라짐을 의미

# 다음의 예제를 보면서 더 쉽게 이해해보자.
# f()     -> 함수 내부의 ls()가 보인다.
# f(ls()) -> 전역 환경에서의 ls()가 보임

f <- function(x = ls()){
  a <- 1
  x
}

f(ls())
f()

# 이러한 평가되지 않은 인자는 프로미스(promise), 또는 썽크(thunk)라고 불림
# 다음 2가지로 구성
# - 지연된 계산을 가져오는 계산식
# - 표현식이 생성되고 평가되어야 하는 환경

# 표현식이 처음 프로미스에 접근할 때, 표현식은 생성된 환경에서 평가됨
# 즉, 함수 내에서 표현식으로 프로미스에 접근 한다면, 함수 내 환경에서 평가된다는 얘기!
# 이 값은 캐쉬되기 때문에 그 이후 접근은 값을 다시 계산하지 않음

# pryr::promise_info()를 사용하면 프로미스에 관한 보다 많은 정보를 찾아볼 수 있음


# ** 느슨한 평가를 활용한 if 문
# 가장 느슨한 평가가 유용하게 사용되는 경우는, if 문이다.
# 다음 예제에서 앞선 !is.null(x)가 FALSE라면, 뒤의 x > 0 를 check 하지 않는다. 즉 x가 null이여도 error가 발생 X

x <- NULL
if(!is.null(x) && x > 0){
  print(x)
}

# 느슨한 평가를 이용하여, if 문을 사용안하고 평가할수도 있다
!is.null(a) || stop("a is null")

# 6.4.5 ... ----
# ... 인자 -> 매칭되지 않은 어떤 인자와도 매칭될 수 있기 때문에 쉽게 다른 함수에 적용 가능
# 장점 : 함수를 매우 유연하게 사용 가능
# 단점 : 문서를 주의깊게 살펴보아야 함. why? 어떤 값이 들어와도 error가 안나기 때문

# 특징
# 개별적인 메소드를 보다 유연하게 해주는 S3 제너릭 함수와 결합하여 사용
# ...를 보다 수월한 형태로 파악하려면 list(...)를 사용해야 함

f <- function(...){
  names(list(...))
}

f(a = 1, b = 2)

# ... 뒤의 인자는 완전한 이름이 있어야함. 철자 오류시 이상한 결과 값을 return

# 6.4.6 연습 문제

# 1. 특이한 함수 호출을 명확히 설명해 보라
#    해당 함수에 ...가 없는 경우, param 명을 명확하게 해주어야 함

x <- sample(replace = T, 20, x = c(1:10, NA))
y <- runif(min = 0, max = 1, 20)
cor(m = "k", y = y, u = "p", x = x)

# 2. 다음의 함수는 무엇을 반환하는가? 그 이유는 무엇인가?
#    이를 설명하는 원칙은 무엇인가?
f1 <- function(x = {y <- 1; 2}, y = 0){
  x + y
}
f1()

# 3. 다음 함수가 반환하는 것은 무엇인가? 그 이유는 무엇인가?
f2 <- function(x = z){
  z <- 100
  x
}
f2()
# -> 함수 내부에서 인자를 선언할 수 있음

# 6.5 특수한 호출 ----
# 함수를 호출하는 특수한 유형(여기서 특수하다는 것은 호출 방식이 특수하다는 것) 2가지 지원
# 1. 삽입 함수(inflx functions)
# 2. 대체 함수(replacement functions)

# 대부분의 함수는 접두 연산자이므로, 함수의 이름이 제일 앞에 옴

# 1. 삽입 함수(inflx functions) ----
# +, -, ^ 등 가운데 오는 것들은 삽입 함수!
# -> 만드려면 앞 뒤에 %를 붙여서 만들어야 함

'%+%' <- function(a, b) paste0(a, b)
"new" %+% "string"

# 함수를 생성할 때 역따옴표(')를 둘러서 만들어야 함 
# 이는 본래의 함수 호출을 위한 syntactic sugar(프로그래밍의 편의성을 높이는 방법)

1 + 5
'+'(1, 5)

# 삽입 함수의 이름은 일반 함수의 이름보다 유연하다(유연하다는 것은 특수문자도 함수명으로 사용할 수 있다는 것을 의미!)
# -> 어떤 문자 시퀀스도 가능!(%는 제외)
# R의 기본적 우선순위 규칙은, 왼쪽에서 오른쪽 방향으로 계산

'%-%' <- function(a, b) paste0("(", a, "%-%", b, ")")
"a" %-% "b" %-% "c" 

# 2. 대체 함수(substitute function) ----
#    함수가 그 함수의 인자들을 수정하는 것 처럼 동작 하는 함수 ex) colnames(x) <- ..
#    xxx<- 라는 특수한 이름을 가짐
#    두 개의 인자(x, value)를 가지며, 수정된 객체를 반환

# 예시. 다음 함수(second)는 두 번째 인자를 변경해주는 함수
'second<-' <- function(x, value){
  x[2] <- value
  x
}

x <- 1:10
second(x) <- 5L
x

# 추가 인자를 삽입 하려면, x와 value 사이에 넣어야 함.
'modify<-' <- function(x, position, value){
  x[position] <- value
  x
}
modify(x, 1) <- 10

# 6.5.3 연습문제 ----
# 1. base 패키지에서 찾을 수 있는 모든 대체 함수의 목록을 생성하라. 어느 것이 원시 함수인가?

repl_nms       <- ls(baseenv(), all.names = T, pattern = "<-$")
repl_objects   <- mget(repl_nms, baseenv())
repl_functions <- Filter(is.function, repl_objects)
length(repl_functions)
names(Filter(is.primitive, repl_functions)) # 최종 원시 함수인 대체 함수 출력! 

# 2. 사용자 생성 삽입 함수의 유효한 이름은 무엇인가? 
# -> 어떠한 시퀀스 문자열도 가능. (but %는 불가)

# 3. xor() 삽입 연산자를 만들어보아라
# -> 두 개중 한개만 참인 경우,
'%xor%' <- function(a, b){
  (a || b) & !(a & b)
}

# 6.6 반환 값 ----
# 함수 내에서 평가된 마지막 표현식 -> return 값
# but, return 함수를 이용해 표현해 주어야 이해가 편함 

f <- function(x){
  if(x < 10){
    0
  }else{
    10
  }
}
f(5)

# 함수는 한개의 객체만을 반환 -> 리스트도 반환 할 수 있음

# ** 순수 함수(pure function) ----
# 항상 같은 입력에 같은 출력을 매핑하고, 작업 공간에 다른 영향을 미치지 않음
# 함수 수행 시, 다른 side effect를 발생시키지 않는 함수를 의미

# 대부분의 R 객체는 수정 후 복사(copy on-modify) 시맨틱스를 가짐
# 즉, 함수 인자를 수정하는 것은 원래의 값을 변화시키지 않음

# 일반적으로 순수 함수를 쓰는 것이 좋다
# 테스트가 쉽고, 상이한 R 버전 또는 상이한 플랫폼에서 서로 다르게 동작할 가능성이 적음

f <- function(x){
  x$a <- 2
  x
}
x <- list(a = 1)

f(x) # 2로 변경됨
x    # 그대로 1!

# 대부분의 R 베이스 함수는 몇 가지 주의할 만한 예외를 제외하면 순수 함수
# 1. library()는 패키지를 로드하여 검색 경로를 수정
# 2. setwd(), Sys.setenv(), Sys.setlocale()은 각각 작업 디렉토리, 환경 변수, 로케일 변경
# 3. plot() 및 이와 관련된 함수는 그래픽 출력을 만듬
# 4. write(), write.csv(), saveRDS()는 출력을 디스크에 저장
# 5. options(), par()는 전역 설정을 수정
# 6. S4 관련 함수는 클래스와 메소드에 대한 전역적 표를 수정
# 7. 난수 생성자는 실행할 때 마다 매번 다른 수를 만들어 냄

# 함수는 보이지 않는 값을 반환 할 수 있음. -> 이런 값은 함수를 호출할 때 기본적으로 출력 X
# invisible function 이용
# -> 보이게 하려면, ()를 감싸서 확인. 
# 보이지 않게 하는 가장 공통적인 함수는 '<-' 

f1 <- function() 1
f2 <- function() invisible(1)

# 하나의 값을 여러 변수에 할당 가능
a <- b <- c <- d <- e <- 2
# 다음과 같이 파싱 되기 때문! : (a <- (b <- (c <- (d <- 2))))

# 6.6.1 나가기(exit) ----
# on.exit function을 이용하여 함수 종료와 동시에 뭔가를 실행할 수 있음
# -> 함수가 종료된 방법, 명시적 반환, 오류 또는 본문의 끝에 도달 여부와 상관 없이 실행
# -> 함수 내에서 에러 여부와 상관없이 전역 변수를 원상태로 돌리거나 할 때, 사용

# 사용 예제
# 특정 디렉토리를 설정 하여 지지고 볶고 한다
# 함수 내부 상태와 상관 없이 원 디렉토리를 설정하기 위하여 on.exit()로 돌려둔다.

in_dir <- function(dir, code){
  old <- setwd(dir)
  on.exit(setwd(old))
  force(code)
}
getwd()
in_dir("~", getwd())

# 6.6.2 연습문제 ----
# 1. source()의 chdir 파라미터는 in_dir()과 어떻게 다른가? 한 접근법을 다른 것보다 선호하는 이유는 무엇인가?
source()

# 2.


# util function 정리
# 1. Filter function
# 첫 번째 인자 : 결과 값이 logical 형태인 함수
# 두 번째 인자 : 확인하고자 하는 objects
# Filter(is.primitive, funs)

# 2. exists function
# 변수가 선언되어 메모리 상에 올라갔는지의 여부를 파악
# ** 반드시 변수명이 문자형으로 들어가야함
a <- NULL
exists("a")
exists("b")

# 3. par function
# par() 함수
# 그래프의 모양을 다양하게 조절할 수 있는 그래픽 인수들을 설정하고 조회하는 함수.

# 4. invisible function
# 함수의 return 값을 안보이게 하는 function -> 먼지 알지?

f1()
f2()
