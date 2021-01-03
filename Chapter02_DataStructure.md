# chapter02 - DataStructure
- 베이스 R(base R)에서 가장 중요한 데이터 구조를 요약
- R의 베이스 데이터 구조는 차원(1차원, 2차원, n차원)과 그 데이터 타입이 동질적인지, 이질적인지에 따라 구조화 될 수 있음
- 데이터 분석에서 가장 자주 사용하는 다섯 가지 데이터 구조 유형을 구성할 수 있음
> || 동질적 | 이질적 |
> |---|:---:|:---:|
> |1차원|원자 벡터|리스트|
> |2차원|매트릭스|데이터 프레임|
> |n차원|어레이||

- <b>R은 0차원 또는 스칼라 유형을 가지지 않는다는 점에 주의하자</b>
- 스칼라라고 생각할 수 있는 개별적인 숫자나 문자는 실제로 길이가 1인 벡터
- 어떤 객체가 주어졌을 때 그것을 구성하는 데이터 구조가 어떤 것인지 알아보기 위한 가장 좋은 방법은 `str`함수를 이용하는 것  
structure의 줄임말로, R의 데이터 구조를 단순하고 사람들이 읽기 편한 형태로 나타냄 

## 2.1 Vector
- R의 기본적인 데이터 구조는 벡터임
- vector는 <b>원자 vector</b>와 <b>리스트</b>가 중요한데, 이는 3가지 속성을 가지고 있음
  - 유형(typeof) --> 어떤 유형인가? 
  - 길이(length) --> 얼마나 많이 가지고 있는가? 
  - 속성(attribute) --> 임의의 추가적 메타 속성은 무엇인가? 
- `is.vector`는 vector를 검증하는 함수가 아님
- <b>객체가 이름 이외에 속성을 가지고 있지 않는 경우 TRUE를 return</b>
- 다음의 예제를 통해서 정확하 이해해보자
~~~R
x <- c(1, NA);               #- NA가 포함된 vector 객체 생성
y <- na.omit(x);             #- na.omit 함수를 통해 NA를 제거한 vector return. 
                             #- 하지만 해당 객체는 na.action이라는 속성도 같이 return 됨
z <- attr(y, "na.action")    #- 확인 결과 TRUE
attributes(y)                #- 속성이 존재함을 확인할 수 있음
is.vector(y)                 #- is.vector를 수행하면 결과적으로 FALSE가 return
~~~
- 따라서 우리가 원하는 vector를 return 하려면, `is.atomic(x) || is.list(x)` 를 사용
- 여기서 말하는 `atomic` 타입은 logical, numeric, integer, character, complex를 말함

### 2.1.1 atomic vector
- 자세히 살펴볼 네 가지 유형의 원자 벡터(atomic vector)는 논리형(logical), 정수형(integer), 더블형(double), 문자형(character) 벡터임
- 앞으로 더이상 사용하지 않을 벡터는 복소수형(complex)와 원시형(raw)임
- 원자 벡터는 보통 combine(or concatenate)의 약자인 c()함수로 생성
~~~R
dbl_var <- c(1, 4.5, 5.5)
int_var <- c(1L, 3L, 5L)  #- 접미사 L을 사용하면 정수형을 얻게 됨
log_var <- c(TRUE, FALSE, T, F)
chr_var <- c("A", "B") 
~~~
- <b>atomic vector는 c()로 감싸더라도 항상 flat(1차원)한 형태</b>
~~~R
# 두 결과는 동일
c(1, c(2, c(3, 4)))
c(1, 2, 3, 4)
~~~
- 결측값은 NA로 나타내며, 길이가 1인 <b>논리형 벡터</b>
- NA를 c()안에서 사용하면 항상 적절한 형태로 형변환됨  
  NA_real_(더블형 벡터), NA_integer_, NA_character_ 라는 특수한 형태의 NA가 생성됨

#### 2.1.1.1 유형과 검증
- 어떤 벡터가 있다고 가정할 때 `typeof()`로 벡터의 타입을 검증하거나 is 함수(ex) is.character()), 또는 이보다 더 일반적인 형태인 is.atomic()를 이용해 그 벡터가 어떤 유형인지 검증할 수 있음
- `is.numeric`은 벡터의 수선에 대한 일반적인 검증. 정수형과 더블형 벡터의 두 가지 경우 모두 TRUE를 반환  
(is.numeric --> integer + double)

#### 2.1.1.2 강제 형변환
- 원자 벡터의 모든 요소는 같은 유형을 가져야 함
- 서로 다른 유형을 결합하려고 할 때 그 요소는 가장 유연한 유형으로 <b>강제 형변환</b>됨 
- 논리형 -> 정수형 -> 더블형 -> 문자형순으로 유연함
~~~R
str(c("a", 1))
# 결과
 chr [1:2] "a" "1"
~~~
- 어떤 벡터가 정수형이나 더블형으로 강제형변환될 때 TRUE는 1이 되고, FALSE는 0이 됨
- 이것은 `sum()`이나 `mean()`을 동시에 사용할 때 유용 
~~~R
x <- c(FALSE, FALSE, TRUE)
as.numeric(x)
# [1] 0 0 1

sum(x)
# [1] 1

mean(x)
# [1] 0.3333333
~~~
- 강제 형변환 수행시 정보를 손실시킬 수 있어 경고 메세지가 나타나므로 
  `as.함수`를 통해 명시적으로 형변환을 해야 함

### 2.1.2 리스트
- 리스트(list)의 요소는 리스트를 포함한 어떤 형도 가능하므로 원자 벡터와는 다름
- 리스트를 생성하려면 `list()`를 사용해야 함
~~~R
x <- list(1:3, "a", c(TRUE, FALSE, FALSE), c(2:3, 5.9))
str(x)
# 결과
 $ : int [1:3] 1 2 3
 $ : chr "a"
 $ : logi [1:3] TRUE FALSE FALSE
 $ : num [1:3] 2 3 5.9
~~~
- 리스트는 <b>재귀 벡터(recursive vector)</b> 라고 부르기도 하는데 그 이유는 리스트가  
  다른 리스트를 포함할 수 있기 때문
- 이것이 원자 벡터와 리스트의 근본적인 차이를 만듬
~~~R
x <- list(list(list(list())))
str(x)
is.recursive(x)
~~~
- `c()`는 여러 리스트를 하나의 객체로 만듬. 만약 어떤 원자 벡터와 리스트가 결합된 형태로 주어졌다면 `c()`는 그 둘을 결합하기 전에 그것들을 리스트로 강제형변환함
~~~R
x <- list(list(1, 2), c(3, 4))
y <- c(list(1, 2), c(3, 4))

str(x)
List of 2
 $ :List of 2
  ..$ : num 1
  ..$ : num 2
 $ : num [1:2] 3 4

str(y)
List of 4
 $ : num 1
 $ : num 2
 $ : num 3
 $ : num 4
~~~
- 리스트에 `typeof()`를 적용한 결과는 list
- `is.list()` 함수로 리스트 여부를 검증할 수 있고 `as.list()` 함수를 이용하여 리스트로 강제 형변환 가능
- `unlist()`를 사용하여 리스트를 원자 벡터로 바꿀 수 있음
- 리스트의 요소들이 서로 다른 유형을 갖고 있을 때 `unlist()`는 `c()`와 같은 강제형변환 규칙을 사용
- 리스트는 R에서 보다 복잡한 데이터 구조를 생성하는데 사용  
  예를 들어 <b>데이터 프레임</b>과 `lm()` 함수로 만들어진 선형 모형 객체는 모두 리스트임 
~~~R
is.list(mtcars)
mod <- lm(mpg ~ wt, data = mtcars)

is.list(mod)
~~~

## 2.2 속성
- 모든 객체는 객체에 관한 메타 데이터를 저장하기 위한 임의의 추가적 속성(attributes)를 가질 수 있음
- 속성은 <b>이름있는 리스트(named list)</b> 처럼 생각 할 수 있음
- 속성은 `attr()`로 개별적으로 접근도 가능하고, `attributes()`로 한 번에 모든 속성에 접근할 수도 있음
~~~R
y <- 1:10
attr(y, "my_attribute") <- "This is a vector"
attr(y, "my_attribute")
"This is a vector"

str(attributes(y))
List of 1
 $ my_attribute: chr "This is a vector"
~~~
- `structure()` 함수는 속성이 수정된 새로운 객체를 반환
~~~R
structure(1:10, my_attribute = "This is a vector")
[1]  1  2  3  4  5  6  7  8  9 10
attr(,"my_attribute")
[1] "This is a vector"
~~~
- 기본적으로 대부분의 속성은 벡터를 수정할 때 상실됨
~~~R
attributes(y[1])
#> NULL
attributes(sum(y))
#> NULL
~~~
- 상실되지 않는 유일한 속성은 다음의 세 가지
  - 이름(names), 각 요소에 이름을 부여하는 문자형 벡터
  - 차원(dimensions), 벡터를 매트릭스와 어레이로 변환하는 데 사용 
  - 클래스(class), S3 객체 시스템을 구현하는 데 사용

- 각 속성은 값을 가져오거나 설정하기 위한 특별한 <b>접근자(access)</b> 함수를 갖고 있음
- 이들 속성에 대한 작업을 할 때는 `attr(x, "names")`, `attr(x, "class")`, `attr(x, "dim")`이 아니라 `names(x)`, `class(x)` 그리고 `dim(x)`를 사용해라

#### 2.2.0.1 이름
- 벡터의 이름(name)은 다음과 같은 세 가지 방법으로 정할 수 있음
  - 생성할 때: `x <- c(a = 1, b = 2, c = 3)` 
  - 작업 공간에 생성되어 있는 벡터를 수정할 때: `names(x) <- c("a", "b", "c")`
  - 벡터의 수정된 사본을 생성할 때 : `x <- setNames(1:3, c("a", "b", "c"))`
- 이름이 반드시 유일할 필요는 없음. 그러나 <b>문자 서브세팅</b>은 이름을 사용하는 가장 중요한 이유이며, 이름이 유일할 때 가장 유용 
- 벡터의 모든 요소가 이름을 가질 필요는 없다. 이름 중 몇개가 생략됐다면 빈 문자열을 리턴
- 이름 전부가 생략됐다면 `names()`는 NULL을 리턴
- `unname(x)`를 이용하여 이름이 없는 새로운 벡터를 생성하거나 `names(x) <- NULL`로 <b>작업 공간(working space)</b>에 있는 이름을 제거할 수 있음

### 2.2.1 팩터(Factor)
- 팩터(factors)를 정의하는 데에는 속성이 중요하게 사용됨
- 팩터는 사전 정의된 값을 담고 있는 벡터로, 범주형 자료를 저장하는 경우에만 사용
- 팩터는 두 가지 속성을 이용하여 정수형 백터 위에 구성
- `class()`는 일반적인 정수형 백터와 팩터를 구분하고, `levels()`는 허용된 값들의 집합을 정의
~~~R
x <- factor(c("a", "b", "b", "a"))
x
#> [1] a b b a
#> Levels: a b

class(x)
#> [1] "factor"

levels(x)
#> [1] "a" "b"
# 수준에 없는 값들을 사용할 수 없음

x[2] <- "c"
#> Warning message:
#> In `[<-.factor`(`*tmp*`, 2, value = "c") :
#> invalid factor level, NA generated

x
#> [1] a    <NA> b    a   
#> Levels: a b

# 주의: 팩터는 결합할 수 없음
c(factor("a"), factor("b"))
#> [1] a b 를 기대하지만,
#> [1] 1 1 의 결과값 return
~~~ 
- 팩터는 변수가 가질 수 있는 가능한 값들을 이미 알고 있을 때 유용
- 이것은 주어진 데이터 세트의 모든 변수를 보지 못할 때도 마찬가지임
- 문자열 대신 팩터를 이용하면 어떤 데이터 세트의 관측값이 없을 때 그 관측값이 없음을 명백히 할 수 있음
~~~R
sex_char   <- c("m", "m", "m")
sex_factor <- factor(sex_char, levels = c("m", "f"))

table(sex_char)
table(sex_factor)
~~~
- 파일에서 바로 읽어 들여 데이터 프레임을 생성했을 때, 수치형 백터라고 생각한 열이 팩터를 생성할 수 있음
- 이는 해당 열의 <b>비수치형(non-numeric)</b> 값 때문에 발생하는 것인데, 흔히 결측값이 또는 -와 같은 특수한 형태로 입력되기 때문
- 이런 현상을 제거하기 위해 그 벡터를 팩터에서 문자형 벡터로 변경한 후 그 문자형 벡터를 더블형 벡터로 변경(이 과정에서 결측값 확인 과정을 반드시 거쳐야 함)
- 물론 이보다 좋은 방법은 처음부터 이런 문제를 발생시키는 원인이 무엇인지를 찾아 수정하는 것
- 이때는 `na.strings`를 이용하는 것이 좋음(na.strings는 특정 문자를 "NA"로 치환해줌)
~~~R
z <- read.csv(text = "value\n12\n1\n.\n9")
typeof(z$value)

#> "character"

as.double(z$value)
#> [1] 12  1 NA  9
#> Warning message:
#> NAs introduced by coercion 

z <- read.csv(text = "value/n12/n1/n./n9", na.strings = ".")
typeof(z$value)
#> [1] "Integer"

class(z$value)
#> [1] "Integer"

z$value
#> [1] 12  1 NA  9
~~~
- R에서 불러오는 대부분의 함수는 문자형 백터를 팩터로 자동 변환함
- 이들 함수를 이용하여 모든 수준(levels)의 집합이나 최적의 순서를 알아낼 수 없기 때문에 추가적인 작업이 필요
- 이런 현상을 억제하기 위해서는 `stringAsFactors = FALSE` 인자를 사용하고, 데이터에 관련된 정보를 활용하여 문자형 벡터를 팩터로 변경해야 함
- 전역 옵션(global option)인 `options(stringAsFactors = FALSE)`를 사용할 수 있지만 권장할 만한 방법은 아님
- 전역 옵션을 바꾸면 다른 코드와 결합(패키지나 source())하여 사용할 때 예상하지 못한 결과를 초래할 수 있음
- <b>팩터가 문자형 백터처럼 보이지만, 실제로는 정수형임</b>
- 팩터를 문자열처럼 다룰 때에는 주의해야 함. `nchar()` 같은 함수는 오류를 발생시키고,   
  `c()` 같은 함수는 기본적인 정수형값을 사용하는 반면 `gsub()`와 `grepl()` 같은 문자열 메소드는  
  팩터를 문자열로 변환함
- <b>문자열 유사 행동(string-like behavior)</b>이 필요하면 명시적으로 팩터를 문자형으로 변환하는 것이 최선의 방법
- 초기 버전 R에서는 문자형 백터 대신 팩터를 사용하는 것이 메모리 사용에 이점이 있었지만, 지금은 그렇지 않음

### 2.3 매트릭스와 어레이
- 원자 벡터에 `dim` 속성을 추가하면 그 벡터는 마치 다차원 어레이(array) 처럼 동작
- 어레이의 특별한 형태는 두 개의 차원을 가지는 매트릭스임
- 매트릭스는 통계학의 수학적 계산에 주로 사용
- 어레이는 자주 사용되지 않지만 주의해야 할 필요가 있음
- 매트릭스와 어레이는 `matrix()`와 `array()`함수나 `dim()`과 같은 <b>할당(assignment)</b>를 이용해 생성
~~~R
a <- matrix(1:6, ncol = 3, nrow = 2)
b <- array(1:12, c(2, 3, 2))
c <- 1:6
dim(c) <- c(3, 2)
dim(c) <- c(2, 3)
~~~
- `length()`와 `names()`는 고차 일반화(high-dimensional generalisations)를 가짐
  - `length()`는 매트릭스에 대해서는 `nrow()`와 `ncol()`, 어레이에 대해서는 `dim()`으로 일반화
  - `names()`는 매트릭스에 대해서는 `rownames()`와 `colnames()`, 어레이에 대해서는 문자형 벡터로 된 리스트인 `dimnames()` 일반화됨
~~~R
length(a)
#> [1] 6 
nrow(a)
#> [1] 2
ncol(a)
#> [1] 3 

rownames(a) <- c("A", "B")
colnames(a) <- c("a", "b", "c")

length(b)
#> [1] 12 

dim(b)
#> [1] 2 3 2

dimnames(b) <- list(c("one", "two"), c("a", "b", "c"), c("A", "B"))
b

#> , , A

#>    a b c
#> one 1 3 5
#> two 2 4 6

#> , , B

#>    a  b  c
#> one 7  9 11
#> two 8 10 12
~~~
- c()는 매트릭스에 대해 `cbind()` 와 `rbind()`로 일반화되며, abind 패키지가 제공하는 `abind()`는 어레이로 일반화됨
- `t()`를 이용하면 매트릭스를 전치(transpose)할 수 있으며, 어레이의 일반화와 동일한 역할을 하는 함수는 `aperm()`임
- 어떤 객체가 매트릭스인지 어레이인지는 `is.matrix()`나 `is.array()`로 확인하거나  
  `dim()`으로 반환되는 객체의 길이로 알 수 있음
- `as.matrix()`와 `as.array()`는 기존의 벡터를 매트릭스나 어레이로 쉽게 변환함
- 벡터는 단순히 1차원 데이터 구조를 말하는 것이 아님. 매트릭스는 하나의 행이나 열로 구성될 수 있고, 어레이 또한 단지 하나의 차원만 가질 수 있음
- 이런 차이는 함수 내에서 타입에 따라 다르게 작동할 수 있다. 그 차이를 알아내려면 `str()`을 사용해라
~~~R
str(1:3) #- 1차원 벡터
#>  int [1:3] 1 2 3
str(matrix(1:3, ncol = 1)) #- 열벡터
#> int [1:3, 1] 1 2 3
str(matrix(1:3, nrow = 1)) #- 행벡터
#> int [1, 1:3] 1 2 3
str(array(1:3, 3)) #- 어레이 벡터
#> int [1:3(1d)] 1 2 3
~~~ 
- 원자 벡터가 주로 매트릭스로 변환되는 반면, <b>리스트-매트릭스(list-matrix)</b>나 <b>리스트-어레이(list-array)</b>를 만들기 위해 그 차원 속성을 리스트에 설정할 수 있음
~~~R
l <- list(1:3, "a", TRUE, 1.0)
dim(l) <- c(2, 2)

#>      [,1]      [,2]
#> [1,] Integer,3 TRUE
#> [2,] "a"       1   
~~~

## 2.4 데이터 프레임
- 데이터 프레임은 내부적으로 동일한 길이를 가지는 <b>벡터로 된 리스트</b>
- 이러한 데이터 프레임은 2차원 구조를 생성하므로 매트릭스와 리스트 속성을 모두 가지고 있음
- 즉 이것은 `names()`의 결과와 `colnames()`가 동일한 것이지만, 구조적으로 데이터 프레임은  
  `names()`, `colnames()`, `rownames()`를 갖고 있다는 것을 의미
- 데이터 프레임의 `length()`는 리스트의 길이 이므로, `ncol()` 과 동일함
- 데이터 프레임을 1차원 구조나 2차원 구조로 서브세팅할 수 있음

### 2.4.1 생성
~~~R
df <- data.frame(x = 1:3, y = c("a", "b", "c"))
str(df)
#> 'data.frame':	3 obs. of  2 variables:
#>  $ x: int  1 2 3
#>  $ y: chr  "a" "b" "c"
~~~
- 문자열을 팩터로 변환하는 `data.frame()`의 기본 동작에 주의해야 함
- 동작을 억제하려면 `stringAsFactors = FALSE`를 사용
~~~R
df <- data.frame(x = 1:3, 
                 y = c("a", "b", "c"), 
                stringAsFactors = F)
~~~

### 2.4.2 검증과 강제형변환
- 데이터 프레임은 S3 클래스이므로 그 유형은 데이터 프레임을 구축하기 위해 사용된 기저 벡터인 리스트를 반영하고 있음(`typeof(df)` 는 list)
- 어떤 객체가 데이터 프레임인지 확인하려면 `class()`를 사용하거나 `is.data.frame()`으로 명확하게 검증해야 함
~~~R
typeof(df)
#> [1] "list"
class(df)
#> [1] "data.frame"
is.data.frame(df)
#> [1] TRUE
~~~
- `as.data.frame()`을 이용하여 객체를 데이터 프레임으로 강제형변환 할 수 있음
  - 벡터는 열이 하나인 데이터 프레임이 됨
  - 리스트는 각 요소에 대해 하나의 열을 생성. 모든 요소의 길이가 같지 않으면 오류 발생
  - 매트릭스는 같은 수의 열과 행을 가진 데이터 프레임이 됨

### 2.4.3 데이터 프레임의 결합
- `cbind()`와 `rbind()`를 이용하여 데이터 프레임 결합 가능
~~~R
cbind(df, data.frame(z = 3:1))
rbind(df, data.frame(x = 10, y = "z"))
~~~
- 열을 기준으로 병합할 때 행의 수가 일치해야 하며 그렇지 않으면 행의 이름이 무시됨
- 행을 기준으로 병합할 때 반드시 열의 수와 이름이 모두 일치해야 함
- 동일한 수의 열을 가지지 않는 데이터 프레임을 결합하려면 `plyr::rbind.fill()`을 사용
- 흔히 벡터를 `cbind()`로 결합하여 데이터 프레임을 생성하려고 하는 실수를 범하는데  
  `cbind()`는 인자 중 하나가 데이터 프레임이 아닐 때 매트릭스를 생성하므로 제대로 동작하지 않음
- 이때는 `cbind()` 대신 `data.frame()`을 사용
- `cbind()`에 대한 변환 규칙은 복잡하므로, 모든 입력을 같은 타입으로 하는 것이 안전

### 2.4.4 특수 열
- 데이터 프레임은 벡터로 된 리스트이므로 리스트인 열도 가질 수 있음
~~~R
df <- data.frame(x = 1:3)
df$y <- list(1:2, 1:3, 1:4)
df

#>  x          y
#> 1 1       1, 2
#> 2 2    1, 2, 3
#> 3 3 1, 2, 3, 4
~~~
- 그러나 리스트가 `data.frame()`에 입력되면 해당 리스트의 각 항목을 열 전체에 삽입하려고 할 것이므로 오류가 발생
~~~R 
data.frame(x = 1:3, y = list(1:2, 1:3, 1:4))

#> Error in (function (..., row.names = NULL, check.rows = FALSE, check.names = TRUE,  : 
#>  arguments imply differing number of rows: 2, 3, 4
~~~
- 이를 회피하는 방법으로 I()를 사용할 수 있는데, 이것은 `data.frame()`이 그 리스트를 한개의 단위로 처리하게 함
~~~R
dfl <- data.frame(x = 1:3, y = I(list(1:2, 1:3, 1:4)))
str(dfl)
~~~
- 이와 유사하게 데이터 프레임과 행의 수가 일치하면 데이터 프레임의 열은 매트릭스나 어레이를 가질 수 있음
~~~R
dfm <- data.frame(x = 1:3, y = I(matrix(1:9, nrow = 3)))
str(dfm)
~~~
- 리스트와 어레이인 열은 사용하지말자

### quiz 풀기 
1. 벡터의 세가지 속성은 무엇인가?

2. 원자 벡터의 네가지 공통유형, 그 중 거의 사용되지 않는 두 가지 유형?

3. 속성이란 무엇인가? 어떻게 이를 확인하고 설정할 수 있는가?

4. 원자 벡터와 리스트는 어떻게 다른가? 데이터 프레임과 매트릭스는 어떻게 다른가?

5. 원자 벡터의 여섯 가지 유형은 무엇인가? 리스트는 원자 벡터와 어떻게 다른가? 

6. is.vector(), is.numeric(), is.list(), is.character()의 근본적인 차이는 무엇인가? 

7. 다음 각 경우에 따라 c()의 출력 결과를 예상해 보고 벡터 강제형변환 규칙에 대해 얼마나 알고 있는지 스스로 확인해보라
~~~R
c(1, FALSE)
c("a", 1)
c(list(1), "a")
c(TRUE, 1L)
~~~

8. 리스트를 원자 벡터로 변환하기 위해 `unlist()` 함수를 사용해야 하는 이유는 무엇인가?  
   왜 `as.vector()`는 제대로 동작하지 않는가? 

9. 1 == "1" 과 -1 < FALSE는 왜 참인가? 반면 "one" < 2는 왜 거짓인가?

10. 결측값에 대한 기본값인 NA는 왜 논리형 벡터인가? 논리형 벡터의 특별한 점은 무엇인가?  
    (힌트 : c(FALSE, NA_character_)를 생각해 보라)

11. 앞에서 `structure()`를 설명하기 위해 다음과 같은 코드를 사용하였다
~~~R
structure(1:5, comment = "my attribute")
#> [1] 1 2 3 4 5
~~~
12. 팩터에서 수준을 수정하면 그 팩터는 어떻게 되는가?
~~~R
f1 <- factor(letters)
levels(f1) <- rev(levels(f1))
~~~
13. 다음 코드를 실행한 결과는 어떠한가? f2와 f3는 f1과 어떤 점에서 다른가? 
~~~R
f2 <- rev(factor(letters))
f3 <- factor(letters, levels = rev(letters))
~~~
14. 벡터에 `dim()`을 적용한 결과는 무엇인가? 

15. `is.matrix(x)`가 TRUE이면 `is.array(x)`의 반환값은 무엇인가? 

16. 다음 세 객체를 설명해 보라. 1:5에 어떤 차이를 만드는가? 
~~~R
x1 <- array(1:5, c(1, 1, 5))
x2 <- array(1:5, c(1, 5, 1))
x3 <- array(1:5, c(5, 1, 1))
~~~
17. 데이터 프레임이 가지는 속성은 무엇인가? 

18. 서로 다른 유형의 열을 가진 데이터 프레임에 `as.matrix()`를 적용하면 어떤 결과가 나타나는가?

19. 행의 수가 0인 데이터 프레임을 가질 수 있는가? 열의 수가 0인 데이터 프레임은 가능한가? 

### 용어 요약
- base R
  - R은 패키지 시스템으로 배포되며, R 설치 시 기본적으로 배포되는 패키지가 base package임