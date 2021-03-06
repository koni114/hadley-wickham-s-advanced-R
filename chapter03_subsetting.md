# chapter03 subsetting
- R의 서브세팅 연산자는 강력하고 빠름
- 서브세팅을 마스터하면 다른 언어가 제공할 수 없는 복잡한 연산을 간결하게 표현할 수 있음
  - 세 가지 서브세팅 연산자
  - 서브세팅의 여섯 가지 유형
  - 다른 객체에 대한 행동의 중요한 차이
  - 할당과 서브세팅의 혼용  

## 3.1 데이터 유형
### 3.1.1 원자 벡터
- 단순한 벡터 x로 서브세팅의 서로 다른 유형을 알아보자
~~~R
x <- c(2.1, 4.2, 3.3, 5.4)
~~~
- 소수점 뒤의 숫자는 벡터 x에서의 원래 위치를 나타낸다는 점에 주의해라
- 벡터를 서브세팅하는 데 사용할 수 있는 다섯 가지 방법이 있음
1. 양의 정수는 특정 위치의 원소를 반환
~~~R 
x[c(3, 1)]
#> [1] 3.3, 2.1

x[order(x)] #- order 함수는 index return
#> [1] 2.1 3.3 4.2 5.4 

#- 중복된 인덱스는 중복된 값을 만듬
x[c(1, 1)]
#> [1] 2.1 2.1

# 실수는 아무런 정보 없이 정수로 축소(버림)
x[c(2.1, 2.9)]
#> [1] 4.2 4.2
~~~
2. 음의 정수는 특정 위치의 원소를 생략
~~~R
x[-c(3, 1)]
[1] 4.2 5.4
~~~
3. 하나의 서브세팅에서 양의 정수와 음의 정수를 혼용할 수 없음
~~~R
x[c(-1, 2)]
#> Error in x[c(-1, 2)] : only 0's may be mixed with negative subscripts
~~~
4. 논리형 벡터는 대응하는 논리값이 TRUE인 곳의 요소를 선택
~~~R
x[c(TRUE, TRUE, FALSE, FALSE)]
#> [1] 2.1 4.2
x[x > 3]
~~~
- <b>만약 논리형 벡터가 서브세팅되는 벡터보다 짧으면 길이가 같아질 때까지 재사용됨</b>
- 인덱스의 결측은 결과에도 항상 결측을 만듬
5. 공백(nothing)은 원래의 벡터를 반환. 공백은 벡터에 유용하지 않지만 매트릭스, 데이터 프레임과 어레이에는 유용. 할당과 혼합하여 사용할 때에도 유용
~~~R
x[]
~~~
6. 영(0)은 길이가 0인 벡터를 반환. 이것은 별다른 목적 없이 사용될 수 있지만, 테스트 데이터를 생성하는 데에는 유용할 수 있음
~~~R
x[0]
#> numeric(0)
~~~
7. 문자형 벡터는 일치하는 이름의 요소를 반환
- [로 서브세팅할 때, 이름은 항상 정확하게 매칭해야 함
~~~R
z <- c(abc = 1, def = 2)
z[c("a", "d")]
#> <NA> <NA> 
#>  NA   NA
~~~

### 3.1.2 리스트
- 리스트를 서브세팅하는 방법은 원자 벡터를 서브세팅하는 것과 동일
- [를 사용하면 항상 리스트를 반환할 것임. [[과 $는 리스트의 요소를 추출

### 3.1.3 매트릭스와 어레이
- 고차원 구조는 세 가지 방법으로 서브세팅할 수 있음
  - 다중 벡터 
  - 단일 벡터
  - 매트릭스
- 2차원인 매트릭스와 2차원을 초과하는 차원의 어레이를 서브세팅하는 가장 공통적인 방법은  
  단순히 1차원 서브세팅을 일반화하는 것
- 각 차원에 쉼표(,)로 구분된 1차원 인덱스를 추가하는 것
- 공백을 사용하는 <b>블랭크 서브세팅(blank subsetting)</b>은 모든 행과 열을 유지할 수 있기 때문에 유용
~~~R
a <- matrix(1:9, nrow = 3)
colnames(a) <- c("A", "B", "C")
a[1:2, ]

#>      A B C
#> [1,] 1 4 7
#> [2,] 2 5 8

a[0, -2]
#>     A C
~~~
- 기본적으로 [는 가능한 낮은 차원으로 결과를 단순화함
- 매트릭스와 어레이는 특별한 속성을 가진 벡터처럼 구현된 것이기 때문에 이것은 하나의 벡터로 서브세팅 할 수 있음
- 이 경우 매트릭스와 어레이는 마치 벡터처럼 동작. 
- R에서 어레이는 열 우선 순서로 저장됨(1열에서 부터 1, 2, 3, ...)
~~~R
vals <- outer(1:5, 1:5, FUN = "paste", sep = ",")
#>      [,1]  [,2]  [,3]  [,4]  [,5] 
#> [1,] "1,1" "1,2" "1,3" "1,4" "1,5"
#> [2,] "2,1" "2,2" "2,3" "2,4" "2,5"
#> [3,] "3,1" "3,2" "3,3" "3,4" "3,5"
#> [4,] "4,1" "4,2" "4,3" "4,4" "4,5"
#> [5,] "5,1" "5,2" "5,3" "5,4" "5,5"

vals[c(4, 15)]
#> [1] "4,1" "5,3"
~~~
- 보다 고차원의 데이터 구조도 정수형 매트릭스로 서브세팅 할 수 있음
- 매트릭스에서 각 행은 한 개의 값의 위치를 의미함 
- 그 위치에서 각 열은 서브세팅되는 어레이의 차원을 의미
~~~R 
vals <- outer(1:5, 1:5, FUN = "paste", sep = ",")
select <- matrix(ncol = 2, byrow = TRUE, c(
    1, 1,
    3, 1,
    2, 4
))
vals[select]
#> [1] "1,1", "3,1", "2,4"
~~~

### 3.1.4 데이터 프레임 
- 데이터 프레임은 리스트와 매트릭스 두 가지 모두의 성질을 가지고 있음
- 한 개의 벡터(c(1, 2))로 서브세팅하면 리스트 처럼 동작
- 두 개의 벡터(c(1,2), c(3,4))로 서브세팅하면 매트릭스처럼 동작
~~~R 
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df[df$x == 2, ]

df[c(1, 3), ]

#- 데이터 프레임에서 열을 선택하는 방법은 리스트의 경우처럼 두가지가 있음
df[c("x", "z")]
df[,c("x", "z")]

#- 두 방식의 차이는 하나의 열을 선택하는 경우,
#- 매트릭스 서브세팅(,c("x","z"))는 단순화함
#- 리스트 서브세팅은 그렇지 않다는 점
str(df["x"])  #- 리스트
str(df[,"x"]) #- 매트릭스
~~~

### 3.1.5 S3 객체
- S3 객체는 원자 벡터, 어레이, 그리고 리스트로 구성되어 있으므로 언제든지 위에서 설명된 기법과 `str()`로 얻어진 정보를 이용하여 S3 객체를 분리할 수 있음

### 3.1.6 S4 객체
- S4 객체의 경우 추가적으로 필요한 서브세팅 연산자가 두 개 있는데, ($와 동일한 역할을 하는) @와([[와 동일한 역할을 하는) `slot()`이 그 둘임
- @은 슬롯이 존재하지 않을 때 오류를 반환한다는 점에서 $보다 제한적임

## 3.2 서브세팅 연산자
- 서브세팅 연산자는 [[와 $의 두 종류가 있음
- [[는 오로지 하나의 값만을 반환하고 리스트로부터 그 일부분을 추출하는 점을 제외하면 [와 비슷
- $는 문자 서브세팅과 결합된 [[의 간단하고 유용한 방법
- 리스트로 작업할 때는 [[가 필요함. 그 이유는 리스트에 [를 사용하면 항상 리스트를 반환하기 때문
- 즉 절대로 리스트의 내용을 반환하지 않음. 리스트의 내용을 얻으려면 [[를 사용해야 함
- [[는 오로지 하나의 값을 반환하기 때문에 이를 이용하여 서브세팅할 때는 양의 정수 또는 문자열 중 하나를 사용해야 함
~~~R
a <- list(a = 1, b = 2)
a[[1]]
#> [1] 1 

a[["a"]]
#> [1] 1

b <- list(a = list(b = list(c = list(d = 1))))
b[[c("a", "b", "c", "d")]]

# 다음의 경우에도 동일
b[["a"]][["b"]][["c"]][["d"]]
~~~
- 데이터 프레임은 열로 된 리스트이므로 데이터 프레임에서 열을 추출하는 데 `mtcars[[1]]` 이나
`mtcars[["cyl"]]` 처럼 [[를 사용할 수 있음
- S3 객체와 S4 객체는 [와 [[의 표준적 행동을 무시할 수 있으므로 서로 다른 유형의 객체에 상이하게 동작함
- 단순형과 유지형 사이에서 선택하는 방법과 기본값이 무엇인지가 주요한 차이점

### 3.2.1 단순형과 유지형 서브세팅
- 단순형 서브세팅 : 단순한 데이터 구조로 반환
- 유지형 서브세팅 : 입력과 같은 출력 구조를 유지
- 단순형과 유지형 서브세팅은 데이터의 구조에 따라 다름
- 단순형은 다음과 같이 데이터 구조에 따라 약간의 차이가 있음
1. 원자벡터 : 이름제거
~~~R
x <- c(a = 1, b= 2)
x[1]
#> a
#> 1 

x[[1]]
#> [1] 1
~~~
2. 리스트: 리스트 내에 한 요소가 아니라 리스트 내의 객체를 반환
~~~R
y <- list(a = 1, b = 2)
str(y[1])
#> List of 1
#> $ a: num 1

str(y[[1]])
#> num 1
~~~
3. 팩터: 사용되지 않은 수준을 삭제 
~~~R
z <- factor(c("a", "b"))
z[1]
#> [1] a
#> Levels: a b

z[1, drop = T]
#> [1] a
#> Levels: a
~~~
4. 매트릭스 또는 어레이: 어떤 차원의 길이가 1이면 그 차원을 삭제
~~~R
a <- matrix(1:4, nrow = 2)
a[1, , drop = FALSE]
#>       [,1] [,2]
#> [1,]    1    3

a[1, ]
#> [1] 1 3
~~~
5. 데이터 프레임: 출력이 1열이면 데이터 프레임 대신 벡터를 반환
~~~R
df <- data.frame(a = 1:2, b = 1:2)
str(df[1])
#> 'data.frame':	2 obs. of  1 variable:
#>  $ a: int  1 2

str(df[[1]])
#>  int [1:2] 1 2

str(df[, "a", drop = F])
#> 'data.frame':	2 obs. of  1 variable:
#>  $ a: int  1 2

str(df[, "a"])
#>  int [1:2] 1 2
~~~

### 3.2.2 $
- $는 단순화된 연산자로서 x$y는 `x[["y", exact = FALSE]]`와 동일
- mtcars$cly 등 데이터 프레임의 변수에 접근하는 데 자주 사용됨
- <b>$를 잘못 사용하는 흔한 사례는 변수에 저장된 열의 이름이 있을 때 그것을 사용하려 하는 것</b>
~~~R
var <- "cyl" 
mtcars$var   #- mtcars$var는 mtcars[["var"]] 처럼 해석되기 때문에 동작하지 않음

#> NULL
#- 대신 [[ 를 사용해야 함
mtcars[[var]]
~~~ 
- $와 [[의 가장 큰 차이점은 $는 <b>부분 매칭(partial matching)</b>을 한다는 것
~~~R
x <- list(abc = 1)
x$a
#> [1] 1 

x[["abc"]]
#> NULL
~~~
- 이러한 행동을 피하기 위해 전역 옵션인 `warnPartialMatchDollar`를 TRUE로 설정할 수 있음
- 이럴 때에는 다른 코드에도 영향을 미칠 수 있으므로 주의 깊에 사용해야 함

### 3.2.3 결측 / 범위 밖 인덱스
- 인덱스가 범위를 벗어날 경우 [와 [[의 동작 방식이 약간 다름  
  예를 들어 길이가 4인 벡터의 다섯 번째 요소를 추출하려고 하는 경우나  
  NA나 NULL 벡터를 서브세팅하려고 하는 경우
~~~R
x <- 1:4
str(x[5])
#> int NA

str(x[NA_real_])
#> int NA

str(x[NULL])
#> int(0)
~~~
- 다음 표는 원자 벡터와 리스트를 [와 [[ 및 다른 유형의 OOB(out of bound: 범위 밖) 값으로 서브세팅한 결과를 요약한 것
> |연산자|인덱스|원자 벡터|리스트| 
> |---|:---:|:---:|:---:|
> |[|OOB|NA|list(NULL)|
> |[|NA_real_|NA|list(NULL)|
> |[|NULL|x[0]|list(NULL)
> |[[|OOB|Error|Eror
> |[[|NA_real_|Error|NULL
> |[[|NULL|Error|Error
- 입력 벡터에 이름이 있으면 OOB, 결측, 또는 NULL 구성 요소의 이름은 <NA>가 될 것임

## 3.3 서브세팅과 할당
- 모든 서브세팅 연산자는 입력 벡터의 선택된 값을 수정하기 위해 할당과 결합할 수 있음
~~~R
x <- 1:5
x[c(1, 2)] <- 2:3
x
#> [1] 2 3 3 4 5

# LHS의 길이는 RHS와 매칭되어야 함
x[-1] <- 4:1
x
#> [1] 2 4 3 2 1

#- 중복된 인덱스가 있는지 확인하지 않음
x[c(1, 1)] <- 2:3
#>  3 4 3 2 1

# NA가 있는 정수 인덱스를 결합할 수 없음
x[c(1, NA)] <- c(1, 2)
#-  NAs are not allowed in subscripted assignments

# NA가 있는 논리형 인덱스는 결합할 수 있다(NA를 false로 다룸)
x[c(T, F, NA)] <- 1
x
#> [1] 1 4 3 1 1

# 다음과 같은 방법은 조건에 따라 백터를 수정하는 경우 가장 유용하다
df <- data.frame(a = c(1, 10, NA))
df$a[df$a < 5] <- 0
df$a
#> [1]  0 10 NA
~~~
- 공백을 이용한 서브세팅은 원본 객체의 클래스와 구조를 유지하기 때문에 할당과 혼용할 때 매우 좋음
- 다음 두 표현식을 비교해보라. 처음 mtcars는 데이터 프레임으로 유지되고, 두 번째 mtcars는 리스트가 될 것임
~~~R
mtcars[] <- lapply(mtcars, as.integer) #- data.frame
mtcars   <- lapply(mtcars, as.integer) #- list
~~~
- 서브세팅, 할당, NULL을 결합하여 리스트에서 요소를 제거할 수 있음  
  리스트에 NULL 문자열을 추가하려면 [과 list(NULL)을 사용
~~~R
x <- list(a = 1, b = 2)
x[["b"]] <- NULL
str(x)
#> List of 1
#>  $ a: num 1

y <- list(a = 1)
y["b"] <- list(NULL)
str(y)
#> List of 2
#> $ a: num 1
#> $ b: NULL
~~~

## 3.4 응용
- 대부분의 기본적인 기법은 보다 간결한 함수로 래핑되어 있지만(ex) `subset()`, `merge()`, `plyr::arrange()`) 이것들이 어떻게 기본 서브세팅에 구현되어 있는지 이해하는 것이 좋음
- 이런 이해를 통해 기존 함수로는 다룰 수 없었던 새로운 환경에 적응할 수 있음

### 3.4.1 Lookup 테이블(문자 서브세팅)
- 처리과정에서 연산 횟수를 줄이기 위해 미리 연산의 결과를 메모리에 저장
- 문자 매칭(character matching)은 lookup 테이블을 만드는 강력한 도구를 제공
- 예를 들어, 단축어를 변환한다고 가정해 보자
~~~R
x <- c("m", "f", "u", "f", "f", "m", "m")
lookup <- c(m = "Male", f = "Female", u = NA)
lookup[x]
#>       m        f        u        f        f        m        m 
#>  "Male" "Female"       NA "Female" "Female"   "Male"   "Male" 

unname(lookup[x])
#> [1] "Male"   "Female" NA       "Female" "Female" "Male"   "Male"  
~~~
- 결과에 이름이 나타나는 것을 원치 않는다면 `unname()`을 사용해야 함

### 3.4.2 직접 매칭하고 결합하기(정수 서브세팅)
- 여러 개의 열로 된 정보를 갖고 있는 보다 복잡한 lookup 테이블이 있을 수 있음
- 등급이 정수로 표현된 벡터와 그 속성을 설명하는 표가 있다고 가정해보자
~~~R
grades <- c(1, 2, 2, 3, 1)
info <- data.frame(
  grade = 3:1,
  desc  = c("Excellent", "Good", "Poor"),
  fail  = c(F, F, T)
)

#- 매칭 사용
id <- match(grades, info$grade)
info[id, ]

#- 행이름 사용
rownames(info) <- info$grade
info[as.character(grades), ]
~~~
- 매칭해야 할 열이 여러 개라면 그것들을 하나의 열로 축소(`interaction()`, `paste0()`, ``plyr::id()`)하거나, `merge()` 또는 `dplyr::inner_join` 등을 사용할 수 있음

### 3.4.3 무작위 샘플 / 부트스트랩
- 백터나 데이터 프레임의 무작위 샘플링이나 부트스트래핑을 수행 하기 위해 정수 인덱스를 사용할 수 있음. `sample()`은 인덱스 벡터를 생성하고 서브세팅하여 그 값에 접근
~~~R
df <- data.frame(x = rep(1:3, each = 2), y = 6:1, z = letters[1:6])
set.seed(10)

# 무작위적으로 재설정
df[sample(nrow(df)), ]

#- 무작위로 3개의 행만 선택
df[sample(nrow(df), 3), ]

#- 여섯 개의 부트스트랩 사본을 선택
df[sample(nrow(df), 6, rep = T),   ]
~~~
- `sample()`의 인자는 추출할 샘플의 수와 샘플링의 복원 추출 여부를 제어

### 3.4.4 순서화(정수 서브세팅)
- `order()`는 벡터를 입력으로 취해 서브세팅된 벡터가 순서화되는 방법을 설명하는 정수형 벡터를 반환
- 기본적으로 결측값이 벡터의 마지막에 삽입되지만 `na.last = NA`로 그 결측값을 제어하거나 `na.last = FALSE`로 맨 앞에 위치시킬 수 있음
- 2차원 또는 그 이상의 고차원의 경우 `order()`와 정수 서브세팅을 결합하여 사용하면 어떤 객체의 행과 열의 순서를 쉽게 정할 수 있음

### 3.4.6 데이터 프레임의 열 삭제(문자 서브세팅)
- 데이터 프레임의 열을 삭제하는 데에는 두 가지 방법이 있다
1. 각 열은 NULL로 설정할 수 있음
~~~R
df   <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df$z <- NULL
~~~
2. 원하는 열만 반환되도록 서브세팅 할 수 있음
~~~R
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df[c("x", "y")]
~~~
- 만약 원하지 않는 열을 알고 있다면 집합 연산(set operations)을 사용하여 유지할 열을 선택
~~~R
df[setdiff(names(df), "z")]
~~~

### 3.4.7 조건에 따른 행 선택(논리 서브세팅)
- if 구문 내에서 보다 유용한 <b>단락 스칼라 연산자</b>인 &&과 ||가 아니라  
<b>벡터 불리언 연산자</b>인 &와 |를 사용한다는 것을 기억해라
- 부정(negative)을 단순화하는 데 유용한 드모르간의 법칙을 잊지 마라
  - !(X & Y)는 !X | !Y과 같음
  - !(X | Y)는 !X & !Y와 같음
- 간단한 함수로 `subset()`를 사용할 수 있음

### 3.4.8 불리언 대수와 집합(논리 & 정수 서브세팅)
- 집합 연산과 불리언 대수는 자연스럽게 대등한 관계가 성립된다는 것을 알아 두는 것이 좋음
- 다음과 같은 경우에 집합 연산을 사용하는 것은 더욱 효과적임
  - 처음 TRUE 값을 찾고 싶을 때
  - TRUE는 매우 적고, FALSE는 매우 많을 때 집합 표현이 보다 빠르고 저장 공간이 덜 필요할 수 있음
- `which()`는 불리언 표현을 정수 표현으로 변환
- 왠만하면 정수 서브세팅의 변환을 피해야 하는데, 그 이유는 y가 모두 FALSE일시 x[-which(y)]  
  는 integer(0)로 return 되기 때문


  ### 퀴즈
  - 양의 정수, 음의 정수, 논리형 벡터 또는 문자형 벡터를 서브세팅한 결과는 어떠한가? 
  - 리스트에 [, [[, $를 적용한 결과 차이는 무엇인가?
  - drop = FALSE를 언제 반드시 써야 하는가? 
  - x가 매트릭스일 때 x[] <- 0의 결과는 어떻게 나타나는가? 이것은 x <- 0과 어떻게 다른가? 
  - 범주형 변수의 라벨을 변경하기 위해 이름 있는 벡터를 어떻게 사용할 수 있는가?
