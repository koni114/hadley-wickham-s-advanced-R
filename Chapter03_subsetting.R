# chapter03. subsetting
# setNames, outer, upper.tri(하삼각행렬함수)

# chapter 3  : subsetting ----
# 서브세팅은 관심 있는 조각을 찾아내는 것

## -- atom vector -- ## ----
# subsetting 시 음수와 양수를 혼용해서 사용할 수 없음
x <- c(2.1, 4.2, 3.3, 5.4)
x[c(-1,2)]

# ** 논리형 벡터가 서브세팅되는 벡터보다 짧으면 길이가 같아질 때까지 재사용됨
x[c(T, F)] # -> 다음과 동일 x[c(T,F,T,F)]

# * 인덱스의 결측은 항상 결과에도 결측을 만듬
x[c(T,T,NA,F)]

# 공백은 원래의 벡터를 반환
x[]

# 영(0)은 원래의 벡터를 반환
# 별다른 목적 없이 사용될 수 있지만, 테스트 데이터를 생성하는데는 유용
x[0] # numeric(0)

# 벡터의 attribute로 이름을 지정할 수 있음
# 문자형벡터는 일치하는 이름의 요소를 반환
# -> 활용 방법: 이름으로도 찾아야하고, idx로도 찾아야 할 때 활용하면 좋을 듯!

# setNames function -> vector의 name을 setting

y <- setNames(x, letters[1:4])
y[c("d", "c", "a")]

# 조심! -> 이름으로 subsetting 할때는 정확하게 이름을 매칭해야한다

## -- list -- ## ----
# [] 를 사용하면 항상 리스트를 반환, [[]], $는 리스트의 요소를 추출

## -- matrix and array -- ## ----
# 고차원 구조는 세 가지 방법으로 서브세팅할 수 있음
# 1. 다중 벡터, 2. 단일 벡터, 3. 매트릭스

# 각 차원 위치에 1차원 인덱스를 넣음으로써 서브세팅 가능
# black subsetting은 모든 행과 열을 유지할 수 있기 때문에 유용

a           <- matrix(1:9, nrow = 3)
colnames(a) <- c("A", "B", "C")

a[1:2, ]
a[c(T, F, T), c("B", "A")]

a[0, -2]

# 매트릭스와 어레이는 특별한 속성을 가진 벡터로 볼 수 있으므로,
# 벡터처럼 서브세팅이 가능

# outer function -> 선형대수학에서 정의되는 두 벡터의 Outer product를 생각!
vals <- outer(1:5, 1:5, FUN = "paste", sep = ",")
vals[c(4, 15)] # 열 기준으로 4번째, 15번째 위치의 값들이 추출(위에서부터 아래로 이동됨을 의미)

# 고차원 데이터 구조를 정수 메트릭스(2차원) 값으로 subsetting이 가능
# 행은 원소의 위치, 열은 해당 어레이의 위치를 의미

vals   <- outer(1:5, 1:5, FUN = "paste", sep = ",")
select <- matrix(ncol = 2, byrow = T, c(1, 1, 3, 1, 2, 4)) 

vals[select] # 다음의 결과 값을 반드시 확인해보라

## -- data.frame -- ## ----
# data.Frame은 한 개의 벡터로 서브세팅 하면, 리스트 처럼 동작

df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df[df$x == 2, ]
df[c(1, 3)]     # dataFrame의 subsetting에서 1차원 벡터로 서브세팅하면, 기본적으로 열 우선

# 다음과 같은 상황을 유의하자
# 2개 이상의 열을 서브세팅할 때, -> dataFrame 유지

df[c("x" , "z")] # -> list subsetting 형태
df[,c("x", "z")] # -> matrix subsetting 형태

# list subsetting은 기존 형식을 유지, 메트릭스 서브세팅은 차원이 내려감
df[c("x")]
df[,c("x")]

# S3 객체는 원자 벡터, 어레이, 리스트로 구성되어 있으므로, 
# 언제든지 S3 객체를 분리할 수 있음 

# 연습문제 풀기 ----

# 1. 다음의 일반적 데이터 프레임 서브세팅 오류를 수정하라.
mtcars[mtcars$cyl = 4, ]      # mtcars[mtcars$cyl == 4, ] 
mtcars[-1:4, ]                # mtcars[1:4, ]
mtcars[mtcars$cyl <= 5]       # mtcars[mtcars$cyl <= 5, ]
mtcars[mtcars$cyl == 4 | 6, ] # mtcars[mtcars$cyl == 4 | mtcars$cyl == 6, ]

# 2. x <- 1:5; x[NA]는 왜 5개의 결측을 가지는가?
# -> x[NA] -> 재활용성 적용 -> x[c(NA, NA, NA, NA, NA)] 과 동일

# 3. upper.tri()가 반환하는 것은 무엇인가? 이것으로 매트릭스를 어떻게 서브세팅하는가?
#    이 동작을 설명하기 위해 추가적인 서브세팅 규칙이 필요한가? 
# -> 기존 매트릭스 형태와 동일하게 logical matrix인 경우에는 특별한 조치를 취할 필요 없이,
#    TRUE 에 해당되는 위치의 값이 return 됨

x <- outer(1:5, 1:5,  FUN = "*")
upper.tri(x)    # 하삼각 행렬. orthogonal을 기준(포함)으로 하단에 위치한 값을 의미
x[upper.tri(x)] 


# 4. mtcars[1:20]은 왜 오류를 반환하는가? 이와 유사한 mtcars[1:20, ]은 이와 어떻게 다른가?
# -> mtcars[1:20]은 list subsetting의 형태로, 열 우선하여 subsetting, 따라서 11개가 넘어가므로, error 발생

# 5. 어떤 매트릭스에서 대각 성분(diagonal entries)을 추출하는 함수를 직접 만들어 보라
#    단, 그 함수는 diag(x)와 비슷하게 동작해야 함

diag2 <- function(x){
  n   <- min(nrow(x), ncol(x))
  idx <- cbind(seq_len(n), seq_len(n)) # 대각 행렬의 길이(n)의 값 , 라는 식으로 적용
  x[idx]
}

# 6. df[is.na(df)] <- 0의 결과는 무엇인가? 어떻게 동작하는가?
# is.na(df)는 matrix 형태의 logical 형태로 return
# 따라서 결측인 위치의 값들이 return 됨

## -- 서브세팅 연산자 -- ## ----
# [[ 와 $ 두가지가 존재

# 리스트에서 [] 로 subsetting하는 경우 리스트로 반환, 해당 요소의 값 형태로 반환하려면 [[]] 사용
# [[]] 같은 경우 하나의 값만을 반환하기 때문에 양의 정수 OR 문자열 중 하나만 사용해야함

a <- list(a = 1, b = 2)
a[[1]]
a[["a"]]

# ** 단순형과 유지형 서브세팅 ----
# 단순형(simplifying) 서브세팅 -> 결과를 표현할 수 있는 가장 단순한 데이터 구조 반환
# 유지형(preserving) 서브세팅  -> 결과를 보여줄때 데이터 구조를 유지하면서 구조 반환
# ex) DROP = F를 생략하면 데이터 오류 발생 등..

# factor 형 변수에서 drop = T를 사용하면 leveld의 개수가 drop dwon!! 
x <- as.factor(c("a", "b", "c"))
x[1:2, drop = T]  # 
x[1:2]

# vector : 단순형 같은 경우 이름이 제거됨
x <- c(a = 1, b = 2)
x[1] 
x[[1]]

# list : 리스트 형태로 리턴되느냐, 되지 않느냐의 차이
y <- list(a =  1, b = 2)
str(y[1])
str(y[[1]])

# factor : 사용되지 않은 수준을 삭제
z <- factor(c("a", "b"))
z[1]
z[1, drop = T]

# matrix or array : drop = F로 구조 변경 여부 선택
a <- matrix(1:4, nrow = 2)
a[1, ]          # vector 형태로 return
a[1,, drop = F] # comma를 2개 넣어야 함

# dataFrame : 출력이 1열이면 데이터 프레임 대신 벡터를 반환
df <- data.frame(a = 1:2, b = 1:2)

# 행인 경우,
str(df[1])    # 단순형
str(df[[1]])  # 유지형

# 열인 경우,
df[,1]          # 단순형
df[,1,drop = F] # 유지형

## -- $ -- ## ----
# $는 단순화된 서브세팅 연산자 중 하나
# 데이터 프레임 변수에 접근하는데 자주 사용

# $를 사용한 잘못된 예 -> 특정 변수에 열의 이름이 있을 때 $로 접근하는 경우,
var <- "cyl"
mtcar$var   # error 발생

# 다음과 같은 경우에는 [[]] 를 사용하자
mtcars[[var]]

## *** $와 [[의 가장 큰 차이는 부분 매칭(partial matching)을 한다는 것
# 다음을 꼭 기억하자
x <- list(abc = 1)
x$a                # 신기하게도 나온다는 점을 꼭 기억하자.

## -- 결측 / 범위 밖 인덱스 -- ## ----
# 인덱스 범위를 벗어날 경우, [와 [[의 동작 방식이 약간 다름
# []   는, NA, int(0) return
# [[]] 는, error 발생

x <- 1:4
x[5]   # NA return
x[[5]] # index를 벗어낫습니다.

# 3.2.4 연습문제 ----
# mod <- lm(mpg ~ wt, data = mtcars)와 같은 어떤 선형이 주어졌을 때 잔차의 자유도를 추출
# 그리고 그 모형의 결과 요약(summary(mod))에서 R2를 추출하라

mod <- lm(mpg ~ wt, data = mtcars)

mod$df.residual             # 잔차의 자유도
summary(mod)[['r.squared']] # R2

# -- subsetting과 할당 ----
# 모든 서브세팅 연산자는 할당 연산자(<- OR = )를 통해 수정이 가능

# 서브세팅에서 할당할 때의 특징들
x <- 1:5
x[c(1,2)] <- 2:3
x
# -> [1] 2 3 3 4 5

# 1. 왼쪽에 위치한 벡터 길이와 오른쪽 위치의 벡터 길이는 같아야 함
x <- 1:4
x[-1] <- 4:1 # 길이가 맞지 않다고 경고 뜸. : number of items to replace is not a multiple of replacement length

# 2. 중복된 인덱스가 있는지 확인하지 않음 -> 추가가 안됨
x[c(1,1)] <- 2:3

# 3. NA가 있는 정수 인덱스를 결합할 수 없음 -> 당연
x[c(1, NA)] <- c(1,2) 

# 4. NA가 있는 논리형 인덱스는 결합할 수 있음(NA는 false로 다룸)
# -> 이건 진짜 조심해야 할 필요성이 있음. -> idx에서 vector의 값이 recycling 되기 때문..
x <- 1:5
x[c(T, F, NA)] <- 1

#   -> 결과적으로 프로그래밍 상 error를 안나게 하려면, 논리형 vector로 서브세팅을 하는 것이 좋음
# 다음과 같은 형태의 서브세팅인 경우도 유용!
# -> 해당 컬럼 값에 NA가 포함되어 있지만, NA 값이 변하는 것이 아니라, 그냥 그대로 있음. 데이터의 왜곡이 일어나지 않음
df <- data.frame(a = c(1, 10, NA))
df$a[df$a < 5] <- 0 # 값에 NA가 포함되어 있지만, error 없이 수정이 가능
df$a

# 공백을 이용한 서브세팅 ----
# -> 원본 객체의 객체의 클래스와 구조를 유지하기 때문에 할당과 혼용 시 유용!

mtcars[] <- lapply(mtcars, as.integer) # 그대로 dataframe 으로 유지
mtcars   <- lapply(mtcars, as.integer) # 리스트로 변경됨

# 다음을 한번 생각해보자
# a,b를 요소로 가지고 있는 리스트에 b 요소를 제거하고 싶을 때,
x <- list(a = 1, b = 2)
x[["b"]]<- NULL
str(x)

# a,b를 요소로 가지고 있는 리스트에 b 요소에 NULL 문자를 추가하고 싶을때,
# -> list(NULL) 이용
y <- list(a = 1, b= 2)
y["b"] <- list(NULL)  
str(y)

# 서브세팅 응용 ----
# 1. look up table 응용 -> 문자 매칭 ----
#    테이블을 만드는 강력한 도구를 제공. 단축어를 변환한다고 가정

x      <- c("m", "f", "u", "f", "f", "m", "m")
lookup <- c(m = "Male", f = "Female", u = NA)
lookup[x]
unname(lookup[x])

# 직접 매칭하고 결합하기 -> 정수 서브세팅
# 여러개의 열로 된 정보를 갖고 있는 보다 복잡한 lookup table 이 있을 수 있다.
# 등급이 정수로 표현된 벡터와 그 속성을 설명하는 표가 있다고 해보자

grades <- c(1, 2, 2, 3, 1, 1, 2, 2, 2, 2)
info <- data.frame(
  grade = 3:1,
  desc   = c("Excellent", " Good", "Poor"),
  fail   = c(F, F, T)  
)

# 학생 10명의 grade(정수) 만 알고 있을 때, lookup 표를 반복하길 원할 때, -> 2가지 방법 가능
# 1. match function 이용
id <- match(grades, info$grade)
info[id, ]

# 2. rownames function 이용
rownames(info) <- info$grade
info[as.character(grades), ]

# ** 매칭해야할 열이 여러개 일 때, 2가지 방법 존재
# 1. 하나의 열로 축소(interaction, paste, plyr::id 이용)
# 2. merge, plyr::join 이용

# 2. 무작위 샘플 / 부트스트랩(정수 서브세팅) ----
df <- data.frame(x = rep(1:3, each = 2), y = 6:1, z = letters[1:6])
set.seed(10)

# 1. 무작위로 재설정.
df[sample(nrow(df)),]

# 2. 무작위 적으로 3개의 행을 설정
df[sample(nrow(df), 3), ]

# 3. 여섯 개의 부트스트랩 사본을 선택
df[sample(nrow(df), 6, rep = T), ]

# 3. 순서화(정수 서브세팅) ----
#    order()는 벡터를 입력으로 취해 서브세팅된 벡터의 순서화되는 index를 return
#    연결을 끊기 위해 order()에 추가로 변수를 삽입할 수도 있음
#    decreasing = T를 이용하여 오름차순에서 내림차순으로 변경할 수도 있음
#    기본적으로 결측값이 벡터의 마지막에 삽입되지만, na.last = NA로 그 결측값을 제어하거나 
#    na.last = F로 맨 앞에 위치시킬 수 있음

x <- c("b", "c", "a")
x[order(x)]

# 2차원 또는 그 이상의 고차원인 경우, order()와 정수 서브세팅을 결합하여 사용하면,
# 어떤 객체의 행과 열의 순서를 쉽게 정할 수 있음

df2 <- df[sample(nrow(df)), 3:1]
df2[order(df2$x),]     # 열 중, x열의 오름차순 순으로 정렬
df2[order(names(df2))] # 열 순서를 정렬 시킴

# 집계의 확장(정수 서브세팅) ----
# 동일한 열을 하나로 축약하고 데이터 빈도수를 계산한 열을 추가하는 경우가 있다.

# x, y -> value, n -> frequency
df <- data.frame(x = c(2, 4, 1), y = c(9, 11, 6), n = c(3, 5, 1))
df[rep(1:nrow(df), df$n),]

# 데이터 프레임의 열 삭제(문자 서브세팅) ----
# 1. 각 열을 NULL로 설정
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df$z <- NULL

# 2. 원하는 열만 반환
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df[c("x", "y")]

# 3. 집합 연산(set operation)
df[setdiff(names(df), "z")]

# 조건에 따른 행 선택(논리 서브세팅) ----
# 일반적으로 가장 많이 하는 slicing 기법
# 중요한 Tip은, 일반적으로 사용하는 && 나 ||(단일 스칼라 연산자 -> T,F의 단일 스칼라 값이 나옴!, short-circuiting scalar operators)를 사용하는 것이 아니라, 
# & 과 | (벡터 불리언 연산자, 해당 로지컬 계산 값 vector 가 나옴. vector boolean operator)를 사용함

mtcars[mtcars$gear == 5, ]
mtcars[mtcars$gear == 5 & mtcars$cyl == 4, ]

subset(mtcars, gear == 5)
subset(mtcars, gear == 5 & cyl == 4)

# which function
# -> boolean 표현을 정수로 변환
# -> TRUE 위치의 index로 return
# which에 대한 역연산을 하는 함수를 만들어 보자. (base에는 없다)

unwhich <- function(x, n){
  out <- rep_len(F, n)
  out[x] <- T
  out
}

x <- c(T, F, T, T, F)
unwhich(which(x), length(x))

x1 <- 1:10 %% 2 == 0
x2 <- which(x1)

y1 <- 1:10 %% 5 == 0
y2 <- which(y1)

# intersection(x,y) <-> x & y
x1 & y1
intersect(x2, y2)

## ** Tip: 일반적인 경우에, 정수 서브세팅보다, 논리 서브세팅을 이용하는 것이 맞다.
# why? 정수 서브세팅을 이용할때, 해당 서브세팅이 NULL(-> integer(0)) 일 때,
# 역 연산을 진행할때, (-> -integer(0)) 는 다시 integer(0)으로 나온다.
# 논리 서브세팅 같은 경우는 전부 F인 경우, 역 연산을 진행하면, 전부 T로 나옴
# 즉 버그를 피할 수 있음!!

# 다음을 통해 더 확실하게 확인할 수 있을 것이다.

x[which(x)]

# 연습 문제 ----
# 1. 데이터 프레임의 열을 랜덤하게 순서를 바꾸는 방법?(이는 램덤 포레스트에서 중요하게 사용되는 기법)
#    한 번에 열과 행을 동시에 치환할 수 있는가?

iris[sample(colnames(iris))]
iris[sample(rownames(iris)), sample(colnames(iris))]

# 2. 데이터 프레임에서 어떻게 m행의 무작위 샘플을 선택할 수 있는가?   
#    인접한 샘플을 선택 해야 한다면 어떻게 해야 하는가?

a <- 10 # first row idx
b <- 20 # last  row idx
iris[sample(seq(a,b)),]

# 3. 어떻게 데이터 프레임에 알파벳 순으로 열을 삽입 할 수 있는가? 
iris[order(names(iris))]


