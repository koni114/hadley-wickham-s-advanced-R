# chapter05 - styleGuide
- 구글의 R 코딩 가이드를 기반으로 하고 있음
- Yihui Xie의 formatR 패키지를 통해 지저분하게 작성된 코드를 쉽게 정리 할 수 있음

## formatR package 정복하기

### 1. formatR package 설치
~~~r
install.packages("formatR")
require(formatR)
~~~

### 2. tidy_source function
- 코드나 코멘트의 긴 라인을 적절하게 짧게 바꿔줌
- 필요하면 스페이스나 indent를 추가해줌
- 대부분의 케이스에서 커멘트가 유지됨
- 코드를 들여쓰기 할 공간의 수를 지정할 수 있음
- {} 없이 else가 사용된 경우, one line back 으로 이동됨
- = 이 <- 로 변경됨
- { 이 새로운 라인으로 변경
- -> 사용 방법 : 내가 확인하고자 하는 R code를 clipboard에 저장하고, 다음 문구를 실행 
~~~r
tidy_source(width.cutoff = 50)
~~~

### 3. tidy_dir function
- reformat된 소스를 해당 디렉토리에 저장

### 4. usage function
- 특정 함수에 대한 사용법을 return 해줌
~~~r
formatR::usage(glm, width = 40)
glm(formula, family = gaussian, data,
     weights, subset, na.action,
     start = NULL, etastart, mustart,
     offset, control = list(...),
     model = TRUE, method = "glm.fit",
     x = FALSE, y = TRUE,
     contrasts = NULL, ...)
~~~

## 5.1 표기법과 이름 짓기
### 5.1.1 파일 이름
- 파일 이름은 반드시 의미가 있어야 하고, .R로 끝나야 함

### 5.1.2 객체 이름
- 변수와 함수 이름은 반드시 소문자여야 함

## 5.2 문법
### 5.2.1 여백 주기
- 모든 삽입 연산자(=, +, -, <- 등) 주위에 여백(spcae)를 사용
- 항상 , 뒤에 여백을 사용
~~~r
average <- mean(feet / 12 + inches, na.rm = T) # o
average<-mean(feet/12+inches,na.rm=T)          # x
~~~
- 예외적으로 ::, :::는 여백이 필요하지 않음
~~~r
x <- 1:10   # o
x <- 1 : 10 # x
~~~
- 여백은 함수를 호출할 때는 넣지 않고, 왼쪽 괄호 앞에는 넣는다
~~~r
if (debug) do(x)  # o
plot(x, y)

if(debug)do(x)    # x
plot (x,y)
~~~
- 등호나 할당(<-)의 정렬을 개선하기 위해서라면, 추가 여백 허용
~~~r
list(
  total = a + b + c,
  mean  = (a + b + c) / n
)
~~~
### 5.2.2 중괄호
- 중괄호 안에서는 반드시 들여쓰자
~~~r
if (y < 0 && debug) {       # o
  message("Y is negative")
}

if (y < 0 && debug)         # x
  message("Y is negative")
~~~
- 매우 짧은 구문을 한 줄에 쓰는 것은 허용!
~~~r
if (y < 0 && debug) message("Y is negative")
~~~





