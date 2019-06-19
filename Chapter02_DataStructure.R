#' 해들리위컴 advanced R 간략 정리
#' 2019_05_27
#' 항상 꾸준히 공부하기!
#' 

# quiz
# 벡터의 3가지 속성? 
# -> 유형, 길이, 속성

# 원자 벡터의 네가지 공통유형,그 중 거의 사용되지 않는 두 가지 유형?
# -> 논리형, 정수형, 더블형, 문자형 // 복소수형, 원시형

# 속성이란 무엇인가? 어떻게 이를 확인하고 설정할 수 있는가?


# 원자 벡터와 리스트는 어떻게 다른가?, 데이터 프레임과 매트릭스는 어떻게 다른가?

#' vector
#' R의 기본적인 데이터 구조는 vector 
#' 벡터는 원자 vector와 리스트가 중요한데, 이는 3가지 속성을 가지고 있음
#' 
#' 1. 유형 : typeof    -> 어떤 유형인가?
#' 2. 길이 : length    -> 얼마나 많이 가지고 있는가?
#' 3. 속성 : attribute -> 임의의 추가적 메타 데이터는 무엇인가?
#' 

# ** is.vector는 vector를 검증하는 함수가 아니다.
#   단지 객체가 이름과 같은 속성을 가지는 경우 TRUE를 반환한다
#   따라서,  is.atomic(x) || is.list(x) 를 사용하자

# 4가지 유형의 원자 벡터
# 논리형, 정수형, 더블형, 문자형 벡터
# 더 이상 사용하지 않을 유형의 벡터 -> 복소수형, 원시형

# 접미사 L을 사용하면, 정수형 벡터 
test <- c(1L, 6L, 10L)


# 원자 벡터는 c()로 계속 감싸더라도 1차원
c(1, c(2, c(3, 4)))

# ** 결측 값은 NA로 표시되며, 길이가 1인 논리형 벡터
# NA를 c() 안에서 사용하면 항상 적절한 형태로 강제 형변환 됨
# NA_real_(더블형 벡터), NA_integer_, NA_character_ 라는 특수한 형태의 NA가 생성

# * 유형과 검증
# typeof(), is 함수 이용

# is.numeric()은 벡터의 수선에 대한 일반적 검증
# 정수형과 더블형 벡터의 두가지 경우 모두 TRUE를 반환

# 원자 벡터는 반드시 같은 형을 가져야 한다(python과 다른 특징)
# 따라서 논리형 < 정수형 < 더블형 < 문자형 순으로 유연함을 가지고 있다
str(c("a", 1)) # 숫자형과 문자형을 같이 쓰면 강제형변환에 의해 문자형으로 변환

# 강제 형변환 때문에 논리형에 대한 수치적 계산이 가능하다.
# sum, mean과 같은 함수를 사용할때 논리형 TRUE는 1, FALSE는 0으로 변환되므로, 계산이 가능하다
# but 강제 형변환 되기 전에 반드시 as 함수를 통해 명시적인 형변환을 하는 것이 좋다

# ** 리스트
# 리스트 안에 리스트를 가질 수 있으므로, recursive vector 라고도 부름
# is.list를 통해 list 여부 확인
# unlist 를 통해 원자 벡터로 변환 가능. 이때 강제형변환 규칙 적용

# 벡터 강제 형변환 규칙 맞춰보자
c(1, FALSE)
c("a", 1)
c(list(1), "a") 
c(TRUE, 1L)

# 리스트를 원자 벡터로 전환할때는, unlist() 이용 -> as.vector()는 제대로 동작하지 않음
# why ? 리스트 자체도 형이 다른 벡터이기 때문이다!

# 결측값에 대한 기본값인 NA는 왜 논리형인가?
# -> 논리형은 어떠한 형으로는 강제 형변환이 가능하다. 즉 NA는 결측이므로 객체의 타입에 영향을 미치면 안되기 때문이다.

#' ** attribute(속성)
#'  모든 객체는 메타 데이터 저장을 위한 추가적 속성을 가질수 있음
#' 속성은 이름있는 리스트로 생각할 수 있음 
#' attr() 함수로 개별적으로 접근도 가능하고, attributes()로 한 번에 모든 속성에 접근 가능
#' 기본적으로 대부분의 속성은 벡터 수정시 삭제됨

y <- 1:10
attr(y, "my_attribute") <- "This is a vector"
attr(y, "my_attribute")
str(attributes(y)) # 모든 속성에 접근 가능

# structure() : 속성이 수정된 새로운 객체 반환
structure(1:10, my_attribute = "This is a vector")

attributes(y[1])
attributes(sum(y))

# 상실되지 않는 유일한 속성 3가지
# 1. 이름 : 각 요소에 이름을 부여하는 문자형 벡터
# 2. 차원 : 벡터를 매트릭스와 어레이로 변환하는데 사용
# 3. 클래스 : S3 객체 시스템을 구현하는 데 사용

# 각 속성은 값을 가져오거나 설정하기 위한 특별한 접근자를 가지고 있음
# 보통 이름 속성을 가지고 온다고 하면, attr(x, "names") 라고 해야하는 것이 맞지만, 특별한 접근자인 names 를 통해서 수정도 가능하다
# dim(x), class(x)를 사용하자

# 1. 벡터의 이름
# 1.1 생성할 때, x <- c(a = 1, b = 2, c = 3)
# 1.2 작업 공간에 있는 벡터를 수정할 때 names(x) <- c("a", "b", "c") 
#                                       names(x)[[1]] <- c("a")
# 1.3 벡터의 수정된 사본을 생성 할 때: x <- setNames(1:3, c("a", "b", "c"))

# 벡터는 서브세팅시 유용하게 사용. 유일할 필요는 없음
# 벡터의 이름중 몇개가 생략된 경우, 공백 문자열로 return
# 모든 이름 생략시 NA return

# 작업 공간에 있는 name 제거 필요시 unname 또는 names(x) <- NULL 사용


# ** factor
# factor는 사전 정의된 값을 가지고 있는 벡터
# 범주형 자료를 저장하는 경우에 사용
# 두 가지 속성을 이용하여 정수형 벡터 위에 구성
# class()  : 일반적인 정수형 벡터와 펙터를 구분
# levels() : 펙터 중 가능한 값의 집합을 보여줌

x <- factor(c("a", "b", "b", "a"))
class (x)
levels(x)  
x[2] <- "c"                 # ** 수준에 없는 값을 사용할 수 없음. NA로 바뀜
c(factor("a"), factor("b")) # factor는 결합 할 수 없음

# factor는 가질 수 있는 가능한 값 들을 이미 알고 있을 때 유용
# factor를 사용하면 그 관측값이 없음을 명백히 할 수 있음 : table 함수 이용

gender_char <- c("m", "m", "m")
gender_char <- factor(gender_char, levels = c("m", "f"))
table(gender_char)

# ** DF에서 읽어들일때 수치형 -> 범주형으로 올라옴
# why? . OR / 와 같이 특수문자 때문
# 이때 na.strings parameter를 이용해서 방지할 수 있음
# na.strings 는 특정 문자를 NA로 바꿔줌
# 하지만 na.strings는 모든 경우에 대처하기가 어려우므로, stringAsFactors = FALSE 인자를 사용

# factor는 정수형처럼 다루어야 함
# -> 문자형 관련 함수를 이용하면 에러 발생 ex) nchar(), gsub(), grepl()
# 최근에 factor 와 character는 메모리 사용 측면에서 비슷해짐

# 연습 문제
# 다음의 객체를 출력할 때, comment attributes는 보이지 않는 이유? 
structure(1:5, comment = "my attribute")
# -> comment attribute는 기본적으로 print 할 때 보이지 않음

# factor에서 수준을 수정하면 어떻게 되는가?
f1 <- factor(letters)
levels(f1) <- rev(levels(f1)) 
# -> 뒤집어서 출력된다

# 다음의 f2, f3는 f1과 뭐가 다른가?
f2 <- rev(factor(letters))                   # 값 자체만 reverse
f3 <- factor(letters, levels = rev(letters)) # 수준만 reverse


## ** 매트릭스와 어레이
# 어레이는 다차원 매트릭스라고 생각하면 좋음
# 원자 벡터에 dim 속성을 추가하면, 다차원 어레이처럼 동작
# 어레이의 특별한 형태는 두 개의 차원을 가지는 매트릭스
# 매트릭스는 통계학의 수학적 계산에 주로 사용
# 매트릭스와 어레이는 matrix(), array() 함수나 dim()과 같은 assignment를 이용해 생성

# matrix, array 함수 이용
a <- matrix(1:6, ncol = 3, nrow = 2)
b <- array(1:12, c(2,3,2))

# dim()을 설정하여 직접 객체 수정도 가능
c <- 1:6
dim(c) <- c(3,2)

# length(), names()는 high-dimensional generalisations을 가짐
# length() : 매트릭스에 대해서는 nrow(), ncol()
# names()  : rownames(), colnames(), dimnames()

# ** 벡터는 단순히 1차원 데이터 구조를 말하는 것이 아니다
#    매트릭스는 하나의 행이나 열로 구성될 수 있고, 어레이 또한 단지 하나의 차원만 가질 수 있음
#    차이를 알아내려면 str()를 이용하자
str(1:3)
str(matrix(1:3, ncol = 1))
str(matrix(1:3, nrow = 1))
str(array(1:3,3))

# ** dataFrame 
# "길이가 같은 벡터로 된 리스트"
# dataFrame은 2차원 구조를 생성하므로, 매트릭스와 리스트 속성 모두를 가지고 있음
# length() : 리스트의 길이가 되므로, ncol()과 동일

# dataFrame 생성
# data.frame()으로 생성. 이름 있는 vector를 받음
df <- data.frame(x = 1:3, y = c("a", "b", "c")) # 기본 동작으로 문자형을 펙터로 변환한다. -> stringAsFactors = FALSE 사용하자

# dataFrame 검증
# 객체가 dataFrame임을 확인하기 위해서는 class(), is.data.frame()을 이용
class(df)
is.data.frame(df)

# dataFrame 강제 형변환
# vector : 하나의 열을 가진 dataFrame
# list   : 각 요소에 대해 하나의 열로 만듬. 열 길이가 안맞으면 error
# matrix : 같은 수의 열과 행을 가진 dataFrame

# dataFrame의 결합
# cbind, rbind 이용 -> 행, 열의 길이가 같아야 함
# 행, 열의 길이가 다른 경우, dplyr::bind_rows, dplyr:bind_cols 사용

# cbind의 경우, 인자 중 하나가 데이터 프레임이 아닐때 matrix로 생성하므로 제대로 동작하지 않음
# -> data.frame()을 이용하자





