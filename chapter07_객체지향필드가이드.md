# chapter07 객체지향 필드 가이드
- R의 객체를 인식하고 작업하는 필드 가이드
- 이 장의 목표는 네 가지 시스템에 대한 전문가가 되도록 하는 것이 아니라, 사용자가 어느 시스템으로 작업하고 있는지를 식별하고, 이를 효과적을 사용할 수 있도록 돕는데 있음
- R의 세 가지 객체지향 시스템(Object-function OO)은 클래스와 메소드가 정의되는 방법에 따라 다름
- 다음 절은 베이스 타입에서 시작하여 각 시스템을 순서대로 설명함
- 어떤 객체가 속해 있는 OO 시스템을 인식하는 방법, 메소드 디스패치가 동작하는 방법, 새로운 객체, 클래스, 제너릭, 메소드를 해당 시스템에 따라 생성하는 방법을 공부하게 될 것임


### S3
- S3는 <b>제너릭-함수 OO(generic-function OO)</b>라고 불리는 OO 프로그래밍 스타일을 구현함
- 이것은 Java, C++, C# 등과 같은 <b>메세지-패싱 OO</b>를 구현한 다른 프로그래밍 언어와는 다름
- 메세지-패싱에서는 메세지가 객체에 전달되고, 메세지를 전달받은 객체가 어느 함수를 호출할지 판단함  
이런 객체는 보통 `메소드/메세지`의 이름 앞에 나타나는 특별한 모습을 가짐
  - ex) `canvas.drawRect("blue")`
- <b>하지만 S3 객체는 다른데, </b> 계산이 메소드를 통해 수행되는 동안, <b>제너릭 함수</b>라고 불리우는 특수한 유형의 함수가 어느 메소드를 호출할 지 선택
  - ex) `drawRect(canvas, "blue")`
- S3는 매우 유연한 시스템이며, 클래스에 대한 형식적인 정의가 없음

### S4
- S4는 S3와 유사하게 동작하지만 보다 형식적임
- S3와는 두 개의 중요한 차이가 존재
- S4는 형식적 클래스 정의를 갖고 있는데, 그것은 각 클래스에 대한 <b>표현(representation)</b>과 <b>상속(inheritance)</b>을 기술하고, 제너릭과 메소드를 정의하는데 도움을 주는 특별한 함수를 갖고 있음
- S4는 <b>다중 디스패치(multiple dispatch)</b>도 갖고 있는데, 이는 제너릭 함수가 여러 개의 인자를 가지는 클래스에 기반을 두고 메소드를 선택할 수 있다는 것을 의미함 

### RC(referene class)
- RC라고 하는 <b>참조 클래스</b>는 S3나 S4와 많이 다름
- RC는 메세지-패싱 OO를 구현한 것으로, 함수가 아니라 클래스에 메소드가 따름
- $는 객체와 메소드를 구분하는 데 사용되므로 메소드 호출은 `canvas$drawRect("blue")`와 같은 모양
- 또한 RC 객체는 가변적이기 때문에 R의 일반적인 수정-후-복사 시맨틱스를 사용하지 않고, 그 자리에서 바로 수정함
- 이것은 그 원인을 알아내기는 어렵지만, S3와 S4로 해결하기 어려운 문제를 풀 수 있도록 함

### base types
- <b>베이스 타입</b>은 다른 OO 시스템의 기본이 되는 C 수준 내부 타입
- 베이스 타입은 대부분 C 코드를 이용하여 조작하지만, 다른 OO 시스템을 구축하는 토대로 제공하므로 알아 두는 것이 좋음

## 7.1  베이스 타입
- 모든 베이스 R 객체에는 그 객체가 메모리에 저장되는 방법을 기술하는 <b>C 구조(또는 구조체 : structure or struct)</b>가 있음
- 구조체는 메모리 관리에 필요한 정보인 객체의 내용과 여기에서 가장 중요하게 다루는 <b>타입(type)</b>을 포함하고 있음
- 이 타입은 R 객체의 <b>베이스 타입</b>(base type)임
  - ex) 원자 벡터, 리스트, 매트릭스, 어레이..등
- 베이스 타입은 R 코어팀만 새로운 유형을 생성할 수 있기 때문에 실제로 객체 시스템은 아님
- 결과적으로 새로운 베이스 타입은 거의 추가되지 않음
- 가장 최근의 변화는 2011년에 이전의 R에서는 전혀 볼 수 없었지만 메모리 문제를 진단하는 데 유용한 두 가지의 색다른 타입을 추가 한 것(NEWSXP, FREESXP)
- 마지막으로 추가된 타입은 2005년 S4에 대한 특별한 베이스 타입
- 2장에서는 가장 공통적인 베이스 타입(ex)원자벡터, 리스트..)를 설명하지만 <b>베이스 타입은 함수, 환경, 이 책에서 나중에 배우게 될 이름, 호출 등 특이한 객체들도 포함하고 있음</b>
- 객체의 베이스 타입은 `typeof()`로 판단할 수 있음
- 베이스 타입의 이름은 R을 통틀어 일관되게 사용되지 않아 타입과 이에 대응하는 `is` 함수는 다른 이름을 사용할 수 있음 
~~~r
#- 함수 타입은 '클로저'임
f <- function() {} 
typeof(f)

#> [1] "closure"

#- 하지만 is 함수는 is.function이 TRUE로 return
is.function(f)
#> [1] TRUE

#- 원시 함수 타입은 `builtin`임
typeof(sum)
#> [1] "builtin"

#- 하지만 is 함수는 is.primitive가 TRUE로 return
is.primitive(sum)
#> [1] TRUE
~~~
- 서로 다른 베이스 타입에 따라 상이하게 동작하는 함수는 거의 C로 쓰여져 있고, switch 구문(ex) switch(TYPEOF(x)))을 사용하여 디스패치가 발생
- C 코드를 작성해 본 적이 없더라도 모든 것이 그 위에 구축되어 있기 때문에 <b>베이스 타입을 이해하는 것은 중요함</b> 
- S3 객체는 어떤 베이스 타입 위에서도 구축될 수 있고, S4 객체는 특수한 베이스 타입을 사용하며, RC 객체는 S4와 환경의 결합
- 어떤 객체가 순수한 베이스 타입인지 여부를 알고 싶다면, 즉 그 객체가 S3, S4, RC 행동을 갖고 있지 않는지 여부를 확인하고 싶다면 `is.Object(x)`가 FALSE를 반환하는지 확인

## 7.2 S3
- S3는 R의 가장 단순한 OO 시스템
- S3는 base 패키지와 stats 패키지에서 사용된 유일한 OO 시스템
- CRAN에 올라와 있는 패키지들에서 가장 공통적으로 사용된 시스템
- S3는 임시적이며 비형식적이지만 그 자체로 미니멀리즘이 반영된 우아함을 가지고 있음
- 즉, 사용자는 이 시스템의 어떤 부분도 분리해낼 수 없지만 여전히 유용한 OO 시스템을 가짐

### 7.2.1 객체 인식, 제너릭 함수 그리고 메소드 
- 마주하게 되는 대부분의 객체는 S3 객체
- 그러나 불행하게도 <b>베이스 R</b>에서 어떤 객체가 S3 객체인지를 쉽게 확인할 수 있는 방법은 없음
- 이에 가장 근접한 방법은 `is.obect(x) & ~isS4(x)` 를 이용하는 것
- 더 쉬운 방법은 `pypr::otype()`을 사용하는 것
~~~r
library(pypr)

df <- data.frame(x = 1:10, y = letters[1:10])
otype(df) #- 데이터 프레임은 S3 객체
#> [1] "S3"

otype(df$x) #- 수치형 벡터는 S3 클래스가 아님
#> [1] "base"

otype(df$y) #- 펙터는 S3 클래스
#> [1] "S3"
~~~
- S3에서 메소드는 <b>제너릭 함수(generic function)</b> 또는 짧게 <b>제너릭(generics)</b>이라고 불리는 함수에 속함
- <b>S3 메소드는 객체나 클래스에 속하지 않음</b>
- 이것은 대부분의 다른 프로그래밍 언어와는 다르지만, OO 스타일이라고 불리우는 데 부족함은 없음
- 어떤 함수가 S3 제너릭인지 판단하기 위해 `UseMethod()` 호출에 대한 소스 코드를 조사해 볼 수 있음
- 즉, 이 함수는 호출에 대한 올바른 메소드, 즉 <b>메소드 디스패치(method dispatch)</b> 과정을 알아내는 함수
- `pryr`은 `otype()`과 유사하게 특정 함수와 객체 시스템이 관련되어 있을 때 그 관련 있는 객체를 설명하는 `ftype()` 이라는 함수도 제공
~~~r
mean

#> function (x, ...)
#> UseMethod("mean")
#> <bytecode: 0x21b6ea8>
#> <environment: namespace:base>

ftype(mean)
#> [1] "s3"      "generic"
~~~
- `[`, `sum()`, `cbind()`와 같은 어떤 S3 제너릭은 C로 구현되어 있기 때문에 `UseMethod()`를 호출하지 않음
- 대신에 이들 함수는 `DispatchGroup()` 또는 `DispatchOrEval()`이라는 C로 작성된 함수를 호출
- C 코드에서 메소드 디스패치를 실행하는 함수는 <b>내부 제너릭(internal generics)</b>이라고 부르며, 내부 제너릭 도움말 문서에 설명되어 있음
- `ftype()`은 이런 특별한 경우에 대한 정보를 제공
- 어떤 클래스가 주어졌다면 S3 제너릭의 역할은 올바른 S3 메서드를 호출하는 것
- 특정 규칙의 이름으로 선언함으로서 S3 메소드를 인식할 수 있는데, `generic.class()` 같은 형태로 나타남
- 예를 들어, `mean()` 제너릭에 대한 `Date` 메소드는 `mean.Date()` 라고 하고, `print()`에 대한 `factor` 메소드는 `print.factor()` 라고 함
- 이것이 최근의 스타일 가이드가 함수 이름에 '.'의 사용을 권하지 않는 이유
- '.'이 함수를 S3 메소드처럼 보이게 하기 때문
- 예를 들면, `t.test()`가 t 객체에 대한 test 메소드인가? 이와 유사하게 클래스 이름에서 '.'를 사용하는 것이 혼란스러울 수 있음
- `print.data.frame()`이 `data.frame()`의 `print()` 메소드인가? 아니면 `frames()`에 대한 `print.data` 메소드인가? 
- `pryr::ftype()`은 이런 예외사항을 알고 있으므로 어떤 함수가 S3 메소드인지 아니면 제너릭인지를 알아내기 위해 사용할 수 있음
~~~r
ftype(t.data.frame) #- t()에 대한 data.frame 메소드
#> [1] "s3" "method"

ftype(t.test)       #- t 검정에 대한 제너릭 함수
#> [1] "s3" "generic"
~~~
- `methods()`를 이용하면 제너릭에 속하는 모든 메소드를 볼 수 있음
~~~r
methods("mean")
#> [1] mean.Date     mean.default  mean.difftime mean.POSIXct  mean.POSIXlt 

methods("t.test")
#> [1] t.test.default* t.test.formula*
~~~ 
- 대부분의 S3 메소드는 base 패키지의 정의되어 있는 메소드와는 달리 별도로 소스코드를 바로 보기가 힘듬. 따라서 해당 소스 코드를 읽으려면 `getS3method()`를 사용해야 함
- 주어진 클래스에 대한 메소드를 가지는 모든 제너릭을 나열할 수도 있음
~~~r
methods(class = "ts")
~~~

### 7.2.2 클래스를 정의하고 객체 생성하기
- S3는 간단하고 형식적인 시스템임. 즉 클래스에 대한 형식적 정의가 없음
- 클래스의 인스턴스인 객체를 만들기 위해 기존의 베이스 객체를 취한 후 클래스 속성을 설정하기만 하면 됨
- 이런 작업은 `structure()`로 생성 중에 하거나 `class<-()` 이후에 할 수 있음
~~~r
# 한 번에 클래스를 생성하고 할당하기
foo <- structure(list(), class = "foo")

# 클래스를 생성하고 난 후 설정하기
foo <- list()
class(foo) <- "foo"
~~~
- <b>S3 객체는 일반적으로 리스트나 속성을 가진 원자 벡터 위에 구축 됨</b>
- 함수를 S3 객체로 만들 수도 있음. 다른 베이스 타입은 R에서 거의 볼 수 없거나 속성과는 잘 다루지 않는 일반적이지 않는 시맨틱스임
- `class(x)`를 이용하여 어떤 객체의 클래스를 판단할 수 있고,     
`inherits(x, "classname")`를 이용하여 어떤 객체가 특정 클래스를 상속했는지 알 수 있음 
~~~r
class(foo)
#> [1] "foo"

inherits(foo, "foo")
#> [1] TRUE
~~~
- S3 객체의 클래스는 벡터일 수도 있음
- 예를 들어, `glm()` 객체의 클래스는 `c("glm", "lm")` 임
- 클래스 이름은 일반적으로 소문자를 사용하며, '.'를 피해야 함
- 그렇지 않으면 복수 단어 클래스 이름에 밑줄(ex) my_class)이나 CamelCase 중 어느 것을 사용할지 혼란스러워짐
- 대부분의 S3 클래스는 <b>생성자 함수(constructor functions)</b>를 제공
~~~r
foo <- function(x){
  if (!is.numeric(x)) stop("X must be numeric")
  structure(list(x), class = "foo")
}
~~~ 
- 가능한 한 이 생성자 함수를 사용해야 함
- 생성자 함수를 사용하면 올바른 요소로 클래스를 명확하게 생성할 수 있음
- 생성자 함수는 일반적으로 클래스 명과 동일한 이름을 가지고 있음 
- 개발자가 제공한 생성자 함수와는 별도로 S3는 정확성을 체크하지 않음. 이것은 기존 객체의 클래스를 변경할 수 있다는 의미
~~~r
# 선형 모형 생성
mod <- lm(log(mpg) ~ log(disp), data = mtcars)
class(mod)
#> [1] "lm"

print(mod)
#> Call:
#> lm(formula = log(mpg) ~ log(disp), data = mtcars)

#> Coefficients:
#> (Intercept)    log(disp)  
#>     5.3810      -0.4586  

# class에 data.frame 삽입하기(?!)
class(mod) <- "data.frame"

#- 그러나 이것은 잘 동작하지 않음을 알 수 있음
#- 중요한 것은 S3는 정확성을 체크하지 않기 때문에 따로 error가 발생하지 않음

print(mod)
#> [1] coefficients  residuals     effects       rank          fitted.values assign        #> qr            df.residual   xlevels       call          terms        
#> [12] model        
#> <0 행> <또는 row.names의 길이가 0입니다>

# 그러나 데이터는 여전히 있음
mod$coefficient
#> (Intercept)  log(disp) 
#> 5.3809725    -0.4585683 
~~~
- 이런 유연성은 문제를 일으키지 않지만, 객체의 유형을 변경할 수 있다고 할지라도 절대 해서는 안됨!

### 7.2.3 새로운 메소드와 제너릭 생성하기
- 새로운 제너릭을 추가하기 위해 `UseMethod()`를 호출하는 함수를 생성해 보자
- `UseMethod()`는 제너릭 함수의 이름과 메소드 디스패치에 사용하기 위한 인자를 취함
- 두 번째 인자를 생략하면 함수의 첫 번째 인자에 디스패치함
- 제너릭 인자의 어떤 것들도 `UseMethod()`에 전달될 필요가 없음
- `UseMethod()`는 그 자체로 인자들을 찾기 위해 알 수 없는 마법 같은 방법을 사용
~~~r
#- f라고 하는 제너릭 함수 선언.
#- f.class 라고 하는 S3 메소드를 선언하여 응용 할 수 있음
f <- function(x) UseMethod("f")
~~~ 
- 제너릭 함수는 메소드가 없으면 유용하지 않음.   
  메소드를 추가하려면 정확한(`generic.class`) 이름으로 정규 함수를 생성하면 됨
~~~r
f.a <- function(x) "Class a"
a <- structure(list(), class = "a")
#> [1] "a"

f(a)
#> [1] "Class a"
~~~
- 기존의 제너릭 함수에 메소드를 추가하면 다음과 같은 방법으로 동작
~~~r
mean.a <- function(x) "a"
mean(a)
#> [1]  a
~~~
- 위에서 볼 수 있는 것과 같이 메소드는 제너릭과 호환되는 클래스를 반환하는지의 여부를 확인하지 않음
- 직접 생성한 메소드가 기존 코드의 예상과 다르지 않은지 확인하는 것은 사용자의 몫

### 7.2.4 메소드 디스패치
- S3 메소드 디스패치는 상대적으로 간단함
- `UseMethod()`는 `paste0("generic", ".", c(class(x), "default"))` 처럼 함수 이름 벡터를 생성한 후 각각을 순서대로 탐색
- `default` 클래스는 다른 알려지지 않은 클래스에 대한 폴백(fallback) 메소드 설정을 가능하게 함
~~~r
f <- function(x) UseMethod("f")
f.a <- function(x) "Class a"
f.default <- function(x) "Unknown class"

f(structure(list(), class = "a"))
#> [1] "Class a"

# b 클래스에 대한 메소드가 없으므로 a 클래스에 대한 메소드를 사용
f(structure(list(), class = c("b", "a")))

# c 클래스에 대한 메소드가 없으므로 기본값으로 돌아감
f(structure(list(), class = "c"))
#> [1] "Unknown class"
~~~
- 그룹 제너릭 메소드(group generic methods)는 약간 복잡도가 더해짐
- 그룹 제너릭은 하나의 함수로 복수의 제너릭에 대한 메소드 구현을 가능하게 함
- 네 개의 그룹 제너릭과 그것들이 포함하는 함수는 다음과 같음
  - Math
  - Ops
  - Summary
  - Complex
- 그룹 제너릭은 고급 기법이여서 이 장의 범위를 벗어나지만, `groupGeneric` 문서에서 더 많은 내용을 찾아볼 수 있음
- 여기서 알아야 할 가장 중요한 것은 `Math`, `Ops`, `Summary` 그리고 `Complex`는 실제 함수가 아니라 함수 그룹을 나타냄
- 그룹 제너릭 함수 내부에서 특수한 변수인 `.Generic`이 호출된 실제 제너릭 함수를 제공한다는 점에 주의해야 함
- 메소드는 일반적인 R 함수이기 때문에 그 메소드를 직접 호출할 수 있음
~~~r
c <- structure(list(), class = "c")
f.default(c)
#> [1] "Unknown class"
~~~
- 그러나 객체의 클래스가 변경될수록 위험하므로 이렇게 해서는 안됨
- 메소드를 직접 호출하는 이유는 성능 개선의 이유도 있는데, 다음에 좀 더 자세히 알아보자
- S3가 아닌 객체로 S3 제너릭을 호출할 수 있음
- 내부 S3 제너릭이 아닌 것들은 베이스 타입의 내재 클래 스(implicit class)에 디스패치됨
- 베이스 타입의 내재 클래스를 판단하는 규칙은 다소 복잡하지만, 다음 함수에서 볼 수 있음
~~~r
iclass <- function(x){
  if (is.Object(x)){
    stop("x is not a primitive type", call = FALSE)
  }

  c(
    if (is.matrix(x)) "matrix",
    if (is.array(x)  && is.matrix(x)) "array", 
    if (is.double(x)) "double", 
    if (is.integer(x)) "integer",
    mode(x)
  )
}
~~~

## 7.3 S4
- S4는 S3와 비슷하게 동작하지만, 형식성(formality)와 강건성(rigour)이 추가됨
- 메소드는 여전히 클래스가 아니라 함수에 속하지만, 다음과 같은 차이가 있음
  - 클래스는 그 필드와 상속 구조(부모 클래스)를 설명하는 형식적 정의를 가지고 있음
  - 메소드 디스패치는 제너릭 함수에 대해 단 하나의 인자가 아니라 복수의 인자에 기초할 수 있음
  - 어떤 S4 객체로부터 슬롯(필드라고도 함)을 추출하기 위한 @라는 특별한 연산자가 있음
- 모든 S4와 관련된 코드는 `methods` 패키지에 저장되어 있음
- 이 패키지는 인터랙티브하게 R을 사용할 때 사용할 수 있지만, 배치 모드에서 R을 실행할 때는 사용할 수 없음
- 이 때문에 S4를 사용할 때마다 명시적으로 `library(methods)`를 포함하는 것이 좋음
- S4는 풍부하고 복잡한 시스템임. 단 몇 페이지로 S4를 충분히 설명할 수 있는 방법은 없음

### 7.3.1 객체, 제너릭 함수, 그리고 메소드의 인식
- S4 객체, 제너릭 함수, 메소드를 인식하는 것은 어렵지 않음 `str()`이 형식적 클래스처럼 설명해 주기 때문에(`isS4()`는 TRUE를 반환하고 `pryr::otype()` 은 S4를 반환) S4 객체를 식별할 수 있음
- S4 제너릭과 메소드도 구별하기 쉬운데, 그 이유는 잘 정의된 클래스의 S4 객체이기 때문
- 공통적으로 사용된 base 패키지(stats, graphics, utils, datasets, base)에는 S4 클래스가 없으므로 내장된 <b>stats4</b> 패키지에서 S4 객체를 생성하는 것으로 시작
- 이는 최대 가능도 추정과 관련된 S4 클래스와 메소드를 제공
~~~r
library(stats4)
library(pryr)

y <- c(26, 17, 13, 12, 20, 5, 9, 8, 5, 4, 8)
nLL <- function(lambda) - sum(dpois(y, lambda, log = TRUE))
fit <- mle(nLL, start = list(lambda = 5), nobs = length(y))

#- S4 객체
isS4(fit)
#> [1] TRUE


otype(fit)
#> [1] "S4"

# S4 제너릭
isS4(nobs)

#> [1] TRUE

ftype(nobs)
#> [1] "s4"  "generic"

mle_nobs <- method_from_call(nobs(fit))
isS4(mle_nobs)

#> [1] TRUE

ftype(mle_nobs)
#> [1] "s4" "method"
~~~
- 객체가 상속한 모든 클래스를 나열하기 위해 인자 하나와 함께 `is()`를 사용해보라
- 어떤 객체가 특정한 클래스를 상속했는지 확인하기 위해 인자 두 개와 함께 `is()` 사용
~~~r
is(fit)
#> [1] "mle"

is(fit, "mle")
#> [1] TRUE
~~~
- `getGenerics()`로 모든 S4 제너릭의 목록을 얻을 수 있고, `getClasses()`로 모든 S4 클래스의 목록을 얻을 수 있음
- 이 목록은 S3 클래스와 베이스 타입에 대한 shim 클래스도 포함
- 선택적으로 generic이나 class에 의한 선택을 제한하면서 `showMethods()`으로 모든 S4 메소드를 나열할 수 있음
- 전역 환경에 사용할 수 있는 메소드에 대한 검색을 제한하기 위해 `where = search()`를 사용하는 것도 좋은 아이디어임

### 7.3.2 클래스를 정의하고 객체 생성하기
- S3에서는 클래스 속성을 설정하는 것만으로도 어떤 객체를 특별한 클래스의 객체로 바꿀 수 있음
- S4는 보다 엄격한데, 반드시 `setClass()`로 클래스의 표현을 정의하고, `new()`로 새로운 객체를 생성해야함
- 예를 들어, `class?mle` 처럼 `class?className`의 특수한 구문으로 특정 클래스에 대한 문서를 찾을 수 있음
- S4 클래스는 세 가지 핵심적인 성질을 가지고 있음
  - 이름(name) : alpha-numeric 클래스 식별자. 관행적으로 S4 클래스 이름은 <b>UpperCamelCase</b>를 사용
  - 슬롯 이름과 허용된 클래스를 정의하는 리스트로 된 <b>슬롯(slots)</b> 또는 <b>필드(fields)</b>. 쉽게 말하면 클래스의 속성을 말함. 예를 들어, 어떤 인물에 대한 클래스는 문자형 이름과 수치형 나이 `list(name = "character", age = "numeric")`처럼 표현할 수 있음
  - 상속받은 클래스를 전달하는 문자열(S4 용어로 contain 이라고 함). 다중 상속에 다중 클래스를 제공할 수 있지만, 더 복잡한 고급 기법
- 슬롯과 콘테인에서 S4 클래스, `setOldClass()`로 등록된 S3 클래스, 베이스 타입의 내재 클래스를 사용할 수 있음
- 슬롯에서 입력을 제한하지 않는 ANY라는 특별한 클래스를 사용할 수 있음
- S4 클래스는 어떤 객체가 유효한지 검증하는 `validity` 메소드와 기본 슬롯 값을 정의하는 `prototype` 객체처럼 선택적 속성을 갖는다
- 다음 사례는 필드 이름과 나이로 Person 클래스와 Person을 상속하는 Employee 클래스를 생성
- Employee 클래스는 Person으로부터 슬롯과 메소드를 상속하고, boss 슬롯을 추가함
- 객체를 생성하기 위해 클래스 이름과 슬롯 값의 이름-값으로 `new()`를 호출
~~~r
setClass("Person",   slots = list(name = "character", age = "numeric"))
setClass("Employee", slots = list(boss = "Person"), contains = "Person")   #- contain을 통해 Person class 상속    

alice <- new("Person",   name = "Alice", age = 40)
john  <- new("Employee", name = "John",  age = 20, boss = alice)
~~~
- 대부분의 S4 클래스는 클래스와 동일한 이름을 가진 생성자 함수를 포함하고 있음
- 이 생성자 함수가 이미 존재하고 있으면 `new()`를 직접 호출하지 말고 그 함수를 사용해라
- S4 객체의 슬롯에 접근하려면 @이나 `slot()`을 사용
~~~r
alice@age
#> [1] 40

slot(john, "boss")
#> An object of class "Person"
#> Slot "name":
#> [1] "Alice"

#> Slot "age":
#> [1] 40
~~~
- S4 객체가 어떤 상속한 S3 클래스나 베이스 타입을 포함하고 있다면, 베이스 타입이나 S3 객체를 포함하는 특별한 .Data 슬롯을 가짐
~~~r
setClass("RangedNumeric", contains = "numeric", slots = list(min = "numeric", max = "numeric"))
rn <- new("RangedNumeric", 1:10, min = 1, max = 10)
rn@min
#> [1] 1

rn@.Data
#> [1] 1 2 3 4 5 6 7 8 9 10
~~~
- R은 인터렉티브한 프로그래밍 언어이므로 언제든지 새로운 클래스를 생성하거나 기존의 클래스를 재정의 할 수 있는데, 클래스를 수정하면, 해당 클래스의 객체들을 전부 다 다시 만들어야 함
- 그렇지 않으면 잘못된 객체가 생성됨

### 7.3.3 새로운 메소드와 제너릭 생성하기
- S4는 새로운 제너릭 함수와 메소드를 생성하기 위한 특별한 함수 제공
- `setGeneric()`은 새로운 제너릭을 생성하거나 기존 함수를 제너릭으로 변환
- `setMethod()`는 제너릭의 이름, 메소드가 연계되어야 할 클래스, 그 메소드를 구현한 함수를 취함
- 예를 들어, 벡터에만 적용하는 `union()`을 데이터 프레임에 동작하도록 만들 수 있음
~~~r
setGeneric("union")
#> [1] "union"

setMethod("union",
  c(x = "data.frame", y = "data.frame"),
  function(x, y){
    unique(rbind(x, y))
  }
)
#> [1] "union"
~~~
- 새로운 제너릭을 처음부터 생성한다면 `standardGeneric()`을 호출하는 함수를 제공할 필요가 있음
~~~r
setGeneric("myGeneric" function(x){
  standardGeneric("myGeneric")
})

#> [1] "myGeneric"
~~~
- `standardGeneric()`은 `UseMethod()`와 동일한 S4임

### 7.3.4 메소드 디스패치
- 어떤 S4 제너릭이 부모가 하나인 단일 클래스에 디스패치되면 S4 메소드 디스패치는 S3 디스패치와 동일해짐
- 주된 차이는 기본값을 설정하는 방법
- 즉 S4는 어떤 클래스에 매칭하기 위한 특별한 클래스인 `ANY`와 결측 인자를 매칭하기 위한 `missing` 클래스를 사용함
- S4는 S3와 유사하게 그룹 제너릭과 부모 메소드를 호출하기 위한 방법으로 `callNextMethod()`를 가짐
- 복수의 인자에 디스패치하거나 생성한 클래스가 다중 상속을 사용하면 메소드 디스패치는 상당히 복잡해짐
- 이 규칙은 `Methods` 도움말에 설명되어 있지만, 매우 복잡하므로 어느 메소드가 호출될지 예측하기 어려움
- 이런 이유 때문에 절대적인 필요가 있지 않는 이상 다중 상속과 다중 디스패치를 사용하는 것을 가능한 한 피하는 것이 좋음
- 결과적으로 제너릭 호출의 특징이 주어졌을 때 어느 메소드가 호출될지를 찾는 메소드가 두 개 남게됨
~~~r
#- 메소드에서 제너릭 이름과 클래스 이름을 취함
selectMethod("nobs", list("mle"))

#- pypr에서 비평가된 함수 호출 취함
method_from_call(nobs(fit))
~~~

## 7.4 RC
- <b>참조 클래스(reference class, RC)</b>는 R의 가장 새로운 OO 시스템
- RC는 S3, S4와 근본적으로 다른데, 다음과 같은 이유 때문
  - RC 메소드는 함수가 아니라 객체에 속함
  - RC 객체는 가변적. 즉 일반적인 R의 수정-후-복사 시맨틱스가 적용되지 않음
- 이런 성질은 RC 객체가 python, Java 등과 같은 다른 프로그래밍 언어에서 동작하는 객체와 유사하게 행동하게 함
- 참조 클래스는 R 코드를 사용하여 구현됨. 즉 어떤 환경을 래핑하는 특별한 S4 클래스

### 7.4.1 클래스 정의하고 객체 생성하기
- 베이스 R 패키지에 의해 제공되는 RC는 전무하므로, 하나를 생성하자
- RC 클래스는 시간에 따라 변환하는 객체인 <b>스테이트풀 객체(stateful objects)</b>를 묘사하는데 사용되므로 은행계좌를 모형화하는 단순한 클래스를 생성해 볼 것임
- 새로운 RC 클래스를 생성하는 것은 새로운 S4 클래스를 생성하는 것과 유사하지만, `setClass()`대신 `setRefClass()`를 사용
- 유일하게 필요한 인자는 클래스명
- 새로운 RC 객체를 생성하기 위해 `use()`를 사용할 수 있지만 새로운 객체를 생성하기 위한 `setRefClass()`에 의해 반환된 객체를 사용하는 것이 좋음
~~~r
Account <- setRefClass("Account")
Account$new()

#> Reference class object of class "Account"
~~~
- `setRefClass()`는 필드 클래스를 정의하는 리스트로 된 <b>name-class pairs</b>를 허용
- `new()`에 전달된 이름 있는 추가 인자는 필드의 초기값을 설정함
- 필드 값은 $로 얻고, 설정할 수 있음
~~~r
Account <- setRefClass("Account", fields = list(balance = "numeric"))
a <- Account$new(balance = 100)
a$balance
#> [1] 100

a$balance <- 200
a$balance
#> [1] 200
~~~
- 필드에 클래스 이름을 제공하는 대신 <b>접근자 메소드</b>처럼 행동하는 하나의 인자 함수를 제공할 수 있음
- 이것으로 필드를 얻거나 설정할 때 사용자 정의된 행동을 추가할 수 있음
- RC 객체가 가변적임을 주의
- RC 객체는 수정-후-복사 시맨틱스가 아니라 참조 시맨틱스를 가짐
~~~r
b <- a
b$balance

#> [1] 200
a$balance <- 0
b$balance
#> [1] 0 
~~~
- 이런 이유로, RC 객체는 객체의 사본을 만들 수 있게 해주는 `copy()`메소드와 같이 사용함
~~~r
c <- a$copy()
c$balance
#> [1] 0

a$balance <- 100
c$balance
#> [1] 0
~~~
- 메소드에 의해 행동이 정의되지 않았다면, 객체는 그다지 유용하지 않음
- RC 메소드는 클래스와 연관되어 있고, 바로 그 필드를 수정할 수 있음
- 다음 사례에서 그 메소드 이름으로 필드 값에 접근하고 `<<-`로 수정하는 것에 주의해라
~~~r
Account <- setRefClass("Account",
  fields  = list(balance = "numeric"), 
  methods = list(
    withdraw = function(x){
      balance <<- balance - x
    },
    deposit = function(x){
      balance <<- balance + x
    }
  ))
~~~
- 필드와 접근하는 것과 동일한 방법으로 RC 메소드 호출
~~~r
a <- Account$new(balance = 100)
a$deposit(100)
a$balance

#> [1] 200
~~~
- `setRefClass()`에 마지막으로 남은 중요한 인자는 <b>콘테인</b>임
- 이것은 메소드들을 상속하기 위한 부모의 RC 클래스의 이름
- 다음 사례는 0 이하의 잔액을 방지하기 위한 오류를 반환하는 새로운 유형의 은행 계좌
~~~r
NoOverdraft <- setRefClass("NoOverdraft",
  contains = "Account",
  methods  = list(
    withdraw = function(x){
      if (balance < x) stop("Not enough money")
      balance <<- balance - x
    }
  )     
)

accountJohn <- NoOverdraft$new(balance = 100)
accountJohn$deposit(50)
accountJohn$balance
#> [1] 150

accountJohn$withdraw(200)
#> Error in accountJohn$withdraw(200) : Not enough money
~~~
- 모든 참조 클래스는 결과적으로 `envRefClass()`를 상속함
- 이 클래스는 앞서 본 `copy()`, 부모필드를 호출하기 위한 `callSuper()`, 주어진 이름에서 필드의 값을 가져오는 `field()`, `as()`와 동등한 `export()`,  그리고 출력을 통제하기 위해 덧쓰는 `show()`를 제공
- 보다 자세한 내용은 `setRefClass()`에서 상속 부분을 보도록 해라

### 7.4.2 객체와 메소드 인식하기
- RC 객체는 `refClass(is(x, "refClass"))`를 상속하는 S4 객체이기 때문에 인식할 수 있음
- `pryr::otype()`은 RC를 반환. RC 메소드는 클래스가 `refMethodDef`인 S4 객체이기도 함

### 7.4.3 메소드 디스패치
- RC에서 메소드 디스패치가 쉬운 이유는 메소드가 함수가 아니라 클래스와 연관되어 있기 때문
- `x$f()` 를 호출 할 때 R은 x의 클래스, 그 부모, 그 부모의 부모에서 f 메소드를 계속 찾아 나갈 것임. 
- 메소드 안에서부터 `callSuper(...)`로 부모 메소드를 직접 호출할 수 있음

## 7.5 시스템 선택 ** 
- 세가지 OO 시스템은 언어 하나의 대한 것으로는 많은 편이지만, 대부분의 R 프로그래밍은 S3만으로 충분함
- R에서는 일반적으로 `print()`, `summary()`, 그리고 `plot()`처럼 기존 제너릭 함수들에 대한 매우 단순한 객체와 메소드를 생성함
- S3는 이런 작업에 적절하므로 R에서 사용했던 OO 코드의 많은 부분이 S3임
- S3는 다소 독특하지만 최소한의 코드로 작업을 완료할 수 있음
- 서로 연관이 있는 객체에 쫌 더 복잡한 시스템을 생성한다면 S4가 보다 더 적절함
- 이에 대한 좋은 예시가 Matrix 패키지와 vignette 패키지임
- RC는 주류 OO 언어로 프로그래밍을 해왔다면 비교적 이해하기 쉬울 수 있음  
  하지만 가변 상태(f(a, b)에서 a,b가 객체이므로, 변할 수 있음)를 통한 파급효과를 조심해야 함

## 용어 정리
- 디스패치(dispatch)
  - 디스패치는 보통 운영체제의 대기 프로세스를 작업 스케줄러에 따라 선택적 우선순위에 따라 실행하는 것을 말하는데, 여기서의 메소드 디스패치는 순차적 동작 방식을 규정하기 위한 방법 정도로 이해할 수 있음


- 폴백 메소드(fallback method)
  - 메소드가 클래스에서 호출되었지만 그 메소드가 존재하지 않으면 이에 대응하기 위한  
    일종의 백업 플랜으로 생각하면 됨

## Quiz
1. 객체가 관련되어 있는 OO 시스템이 무엇인지 어떻게 알 수 있는가? 
2. 객체의 베이스 타입을 어떻게 판단하는가? 
3. 제너릭 함수는 무엇인가? 
4. S3와 S4의 주요 차이는 무엇인가? 그리고 S4와 RC의 주된 차이는 무엇인가?  