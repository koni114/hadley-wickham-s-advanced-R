## chapter07 객체지향 필드 가이드
* R의 객체를 인식하고 작업하는 필드 가이드
* R의 세 가지 객체지향 시스템(Object-function OO)은 클래스와 메소드가 정의되는 방법에 따라 다름

##### S3
  * S3는 generic-function 이라고 불리는 OO 프로그래밍 스타일을 구현
  * Java, C++과 같은 Message-passing OO를 구현한 다른 프로그래밍 언어와는 다름
    * 메소드가 객체에 전달되고, 메소드를 전달받은 그 객체가 어느 함수를 호출할지 판단
    * 이러한 객체는 메소드 이름 앞에 나타남 ex) 객체.메소드("blue", "aa")
  * S3는 계산이 메소드를 통해 수행되는 동안  
  generic function이 어떤 메소드에 매칭시킬지 찾음
    * ex) 메소드(객체, "blue")
  * S3는 매우 유연한 시스템이며, 클래스에 대한 형식적인 정의가 없음

##### S4
* S4는 S3 보다 형식적임
* S4는 형식적인 클래스 정의를 가지고 있는데, 각 클래스에 대한 표현(representation)과 상속(inheritance)을 기술
* 제너릭과 메소드를 정의하는 데 도움을 주는 특별한 함수를 갖고 있음
* S4는 multiple dispatch도 가지고 있음
  * dispatch : 프로그램이 어떤 메소드를 호출할 것인가를 결정하여 그것을 실행하는 과정

##### RC
* 메세지-패싱 OO을 구현한 것으로, 함수가 아니라 클래스에 메소드가 따름
* 함수가 아니라 클래스에 메소드가 따름
* &#36;는 객체와 메소드를 구분하는데 사용. 메소드 호출은 canvas$drawRect("blue")와 같은 모양

##### base type
* 객체 지향은 아니지만, 언급해야 할 중요한 시스템
* base type은 다른 OO 시스템의 기본이 되는 C 수준 내부 타입


### 7.1 base type
* 모든 베이스 R 객체에는 그 객체가 메모리에 저장되는 방법을 기술하는 C 구조체(structure, struc)가 있음
* 구조체는 메모리 관리에 필요한 정보인 type(R 객체의 base type)을 포함
* base type은 R 코어팀만 생성할 수 있기 때문에 새로운 base type은 잘 추가되지 않음
* base type은 atomic vector나 list 같은 기본적인 base type도 있지만 함수, 환경 등 특이한 객체들도 포함되어 있음
* 객체의 base type은 typeof()로 판단 가능
* base type의 이름은 R을 통틀어 일관되게 사용되지 않아 타입과 이에 대응하는 is 함수는 다른 이름을 사용할 수 있음
~~~
함수 타입은 클로저
f <- function(){}
is.function(f)

원시 함수 타입은 builtin
typeof는 bulitin 이지만, is.primitive를 사용하여 확인
typof(sum)
is.primitive(sum)
~~~
* 서로 다른 베이스 타입에 따라 상이하게 동작하는 함수는 C로 쓰여져 있음  
switch 구문을 사용하여 디스패치가 발생(switch(TYPEOF(x)))
* C 코드를 작성해 본 적이 없더라도 모든 것이 그 위에 구축되어 있기 때문에 베이스 타입을 이해하는 것이 중요
* S3 객체는 어떠한 base type 위에서도 구축 될 수 있음
* S4 객체는 특수한 베이스 타입을 사용
* RC 객체는 S4와 환경의 결합

### 7.2 S3
* S3는 R의 가장 간단한 OO 시스템
* S3는 base 패키지와 stats 패키지에서 사용된 유일한 OO 시스템

#### 7.2.1 객체 인식, 제너릭 함수, 메소드
* base R에서 어떤 객체가 S3 인지를 쉽게 확인 할 수 있는 방법은 없음  
가장 근접한 방법은 is.object(x) & !isS4(x) 를 사용하는 것
* 보다 쉬운 방법은 pryr::otype() 을 사용하는 것
~~~
library(pryr)

df <- data.frame(x = 1:10, y = letters[1:10])
otype(df) dataFrame은 S3 Class

otype(df$x)  # 수치형 백터는 S3 클래스가 아님

otype(df$y) # 벡터는 S3 클래스
~~~
* S3에서 메소드는 제너릭(generic)이라고 불리는 함수에 속함
* S3 메소드는 객체나 클래스에 속하지 않음

##### generic method
* S3에서 method는 제너릭 함수(generic function)에 속함
* 넓이를 계산해주는 메소드 area()가 있다고 할 때, rectangle, circle class가 input으로 들어왔을 때 계산 방법은 각각 다름
* 이 때 area function을 generic function 이라고 하며, 이때 area function은 적절한 method를 dispatch 해줌
~~~
area.rectangle <- function(x, ...) {
  as.numeric((x["xright"] - x["xleft"]) * (x["ytop"] - x["ybottom"]))
}

area.circle <- function(x, ...) {
  pi * x$radius^2
}
~~~
* dot(.)을 이용해서 method를 표기하기 때문에 함수명에 dot(.)은 쓰지 않음
* pryr::ftype()를 이용해서 함수가 S3 메소드인지 제너릭인지 확인 가능
~~~
ftype(t.data.frame) # t()에 대한 data.frame 메소드
ftype(t.test) # t검정에 대한 제너릭 함수
~~~
* methods()를 이용하면 제너릭에 속한 모든 메소드를 볼 수 있음
~~~
methods("mean")
methods("t.test")
~~~

#### 7.2.2 클래스를 정의하고 객체 생성하기
* S3는 간단하고 임시적인 시스템이므로 형식적 정의가 없음
* S3 클래스의 객체 생성 방법은 기존의 베이스 객체를 취한 후 class 속성을 설정하면 됨
~~~
foo <- structure(list(), class = " foo") # 한번에 클래스를 생성하고 할당
foo <- list() # 클래스를 생성하고 난 후 설정
class(foo) <- "foo"
~~~
* class(x)로 객체의 클래스를 판단할 수 있고, inherits(x, "classname")을 이용하여 객체가 특정 클래스를 상속했는지 알 수 있음
~~~
class(foo)
inherits(foo, "foo")
~~~
* 대부분의 S3 클래스는 생성자 함수(constructor functions)를 제공
~~~
foo <- function(x){
  if (!is.numeric(x))stop("X must be numeric")
  structure(list(x), class = "foo")
}
~~~
* 개발자가 제공한 생성자 함수와는 별도로, S3는 정확성을 체크하지 않음  
즉, 기존 객체의 클래스를 변경할 수 있음
* 왠만해서는 그런 짓은 하지 않음

#### 7.2.3 새로운 메소드와 제너릭 생성하기
* 새로운 재너릭을 생성하기 위해 UseMethod 사용
* UseMethod에는 제너릭 함수의 이름, 메소드 디스패치에 사용하기 위한 인자를 취함
* 두 번째 인자를 생략하면 함수의 첫 번째 인자에 디스패치함
* 메소드를 정의하여 제너릭을 유용하게 사용
~~~
f <- function(x) UseMethod("f") # 제너릭 정의
f.a <- function(x) "class a"
a <- structure(list(), class = "a")
class(a)
f(a)
~~~

#### 7.2.4 메소드 디스패치
* default 클래스는 알려지지 않은 클래스에 대한 폴백(fall back) 메소드 설정을 가능하게 함
~~~
f <- function(x) UseMethod("f")
f.a <- function(x) "Class a"
f.default <- function(x) "Unknown class"

f(structure(list(), class = c("a", "b")))  # b 클래스에 대한 메소드가 없으므로, a 클래스에 대한 메소드 사용
f(structure(list(), class = c("c"))) # c 클래스는 없으므로, default 적용
~~~
* 그룹 제너릭은 하나의 함수로 복수의 제너릭에 대한 메소드 구현을 가능하게 함
* ex) Math, Ops, Summary, Complex 와 같은 그룹 제너릭은 실제 함수가 아니라, 함수 그룹을 나타내는 것임을 인식하는 것을 반드시 인지해야 함

### 7.3 S4
* S4는 S3와 비슷하게 동작하지만, 다음과 같은 차이가 존재
  * 클래스는 필드와 상속 구조를 설명하는 형식적 정의 존재
  * 메소드 디스패치는 제너릭 함수에 대해 단 하나의 인자가 아니라 복수 인자에 기초
  * S4 객체로부터 slot(필드라고 함)을 추출하기 위한 @이라는 특별한 연산자 존재
* S4와 관련된 코드는 methods package에 저장
* 배치 모드에서 R을 실행할 때 사용할 수 없음. S4를 사용할 때 마다 명시적으로 library(methods) 포함하자


#### 7.3.1 객체, 제너릭 함수, 메소드의 인식
* S4의 객체, 제너릭, 메소드는 인식하기 쉬움
* isS4() : TRUE 반환시, pryr::otype() : S4 반환시 S4 객체 인식 가능
* base 패키지에서는 S4가 존재하지 않으므로, 내장된 stat4 패키지에서 S4 객체를 생성하는 것으로 시작하자
~~~
library(stat4)

y <- c(26, 17, 13, 12, 20, 5, 9, 8, 5, 4, 8)
nLL <- function(lambda) - sum(dpois(y, lambda, log = TRUE))
fit <- mle(nLL, start = list(lambda = 5), nobs = length(y))

isS4(fit) # TRUE
otype(fit) #  "S4"
isS4(nobs) # S4 generic, TRUE
ftype(nobs) # "s4", "generic"
~~~
* 객체가 상속한 모든 클래스를 나열하기 위해 인자 하나와 함께 is()를 사용
* 객체가 특정 클래스를 상속했는지 확인하기 위해 인자 2개 사용
~~~
is(fit)        # "mles"
is(fit, "mle") # TRUE
~~~
* getGenerics()로 모든 S4 제너릭의 목록을 얻을 수 있음
* getClasses()로 모든 S4 클래스의 목록을 얻을 수 있음

#### 7.3.2 클래스 정의, 객체 생성하기
* setClass()로 클래스의 표현 정의하고, new()로 새로운 객체 생성
* S4 클래스는 세 가지 핵심적인 성질을 가지고 있음
  * 이름(name): 관행적으로 S4 클래스 이름은 Upper CamelCase 사용
  * 슬롯(slots)과 필드(fields) : ex) list(name = "character", age = "numeric") 처럼 표현 가능
  * 상속받은 클래스를 전달하는 문자열(S4 용어로 contain 이라고 함). 고급 기법임!
* slot과 contain에서 S4 class, setOldClass()로 등록된 S3 class, 베이스 타입의 내재 클래스를 사용할 수 있음
* S4 클래스는 어떤 객체가 유효한지를 검증하는 validity 메소드와 기본 슬롯 값을 정의하는 prototype 객체처럼 선택적 속성을 가짐
* 예제 - Person class와 이를 상속하는 Employee class 생성 예제
~~~
setClass("Person", slots = list(name = "character", age = "numeric"))
setClass("Employee", slots = list(boss = "Person"), contains = "Person")

alice <- new("Person", name = "Alice", age = 40)
john <- new("Employee", name = "John", age = 20, boss = alice)
~~~
* 대부분의 S4 클래스는 클래스와 동일한 생성자 함수를 포함하고 있음. 생성자 함수가 이미 존재하고 있으면  new()를 직접 호출하지 말고 함수를 사용해라
* S4 객체의 슬롯에 접근하려면 @, slot() 사용
~~~
alice@age
slot(john, "boss")
~~~
* @는 $와 동일하며, slot() 은 [[]] 와 같음




### 퀴즈 풀기
* 객체가 관련되어 있는 OO 시스템이 무엇인지 어떻게 알 수 있는가?
* 객체의 base type을 어떻게 판단하는가?
* 제너릭 함수는 무엇인가?
* S3와 S4의 주요 차이는 무엇인가? 그리고 S4와 RC의 주된 차이는 무엇인가?
