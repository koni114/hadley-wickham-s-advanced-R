## chapter04 어휘
## chapter04 어휘

1. <<- 
- 전역변수의 값을 할당할 때 사용

~~~R
a <- 10
b <<- 10
test <- function(x){
  b <<- 20
  x
}
~~~R

2. identical, all.equal function
-  identical function : 두 개의 객체가 "정확히" 같은지 비교 -> 별로 쓸모 없음
-  all.equal function : 미미한 오차는 무시.

~~~R
x <- 1
y <- 1L
identical(x, y)
all.equal(x, y)
~~~~

3. is.finite function
- ** Tip
- Inf는 infinite의 약자로써, 무한대를 의미
- NaN은 Not a Number의 약자로써 0/0처럼 수학적으로 정의가 되어있지 않은 것을 의미
- ex) 1 / 0 -> Inf가 나옴
- is.infinite function -> Inf와 -Inf가 TRUE로 return

~~~R
# 결과 예시
Z <- c(1/0, -1/0, 0/0, 4, 5)
is.infinite(Z)
~~~

4. trunc function : 숫자형 벡터 처리 함수 중 하나.
- x 소숫점 이하는 잘라서 버림 : trunc(x)

~~~R
trunc(5.88)
trunc(5.10)
~~~

5. rle function
- run length encoding
- 연속 요소의 길이를 계산. 
- length -> 해당 value의 length
- values -> 해당 value
~~~R
dat <- c(1, 2, 2, 2, 3, 1, 4, 4, 1, 1)
r   <- rle(dat)
#> Run Length Encoding
#>  lengths: int [1:6] 1 3 1 1 2 2
#>  values : num [1:6] 1 2 3 1 4 1
~~~

- 해당 요소를 length 와 values로 뽑아 낼 수 있음
  - r$lengths
  - r$values

6. missing function
- 해당 변수가 선언이 되었는지에 대한 여부 파악
- 일반적으로 함수의 param 을 선언하지 않았을 때, 값이 들어왔는지 들어오지 않았는지 파악

~~~R
test <- function(a, b){
  if(missing(a) || missing(b)){
    print("a, b중 하나가 missing")
  }
}
~~~
- test(a = 10) # b는 missing 이므로, print 출력
- t
- test(a = 10) # b는 missing 이므로, print 출력
- test(b = 20) # a는 missing 이므로, print 출력


###  함수 제어를 위한 함수들
1. topifnot function
- 조건문을 통해 FALSE일 때 에러 메세지 반환, 함수 종료.

~~~R
test <- function(x){
  stopifnot(is.numeric(x), all(!is.na(x)))
  print("pass!")
}
test(c(1,2,3,4, NA))
~~~

7. on.exit function
-    함수 종료시 실행 -> 즉 종료되는 시점에 문구가 출력됨!
    add param 값을 T 로 하면, 함수 내에 있는 모든 on.exit 함수 안에 있는 것들이 실행 됨

8. First() / .Last()
- R 시작 및 종료 시 수행.

9. Sys.sleep function
-  일정 시간 만큼 프로세스 수행 지연.

10. invisible function
- 함수의 최종 결과가 console 화면에 출력되지 않도록 하는 함수

11. setequal function
- 집합 간의 비교
- == 과 비교하는데, 중복은 제거하고 같은지를 확인

12. sweep function
- 행렬, 배열, 데이터 프레임에 함수와 통계량을 적용하는 함수

~~~R
sweep(
  x,           # 대상 객체(배열array)
  MARGIN,      # MARGIN : 배열의 차원.
  STATS,       # STATS  : 적용할 통계량
  FUN = "-",   # FUN    : 적용할 함수. (="-"  : 뺄샘 연산.)
  check.margin = TRUE   # check.margin : 인수 길이가 같은지 확인.  
)
~~~

13. data.matrix function
- data.frame를 matrix로 변경
- as.matrix 는 값들을 문자열로 바꿈
- data.matrix는 기본적으로 ** 문자열을 수치형으로 바꿔서 출력해줌.

~~~R
example <- data.frame(Group.1 = c("a", "b", "c", "d"), x = c(1,2,3,4))
data.matrix(example) # Group.1의 값이 변했음을 알 수 있음
~~~

14. seq_along function
- 무조건 1부터 시작하며 백터를 입력 받는데, 백터의 길이만큼 seq가 생성
~~~R
seq_along(4:10) # 4:10 이지만, 시작은 1인 것을 확인
~~~

15. choose function
- N개 중 순서에 상관 없이 n개를 뽑는 경우의 수를 계산 -> N Combination n 
~~~R
choose(45, 6) # 45 C 6 : 8145060
~~~

16. combn function
- n개의 항목 중에, k씩 선택하는 모든 조합 생성
~~~R
combn(1:5, 2) # 1부터 5중에 2개씩 뽑은 모든 조합 생성
~~~

17. split function
- 조건에 따라 데이터를 분리하는 함수 
- vector 나 dataframe 을 분리할 수 있음
~~~R
split(iris, iris$Species) # 3개의 dataframe을 분리해서 list 형식으로 반환
~~~
-  return 형식이 list이므로, lalppy를 사용하여 적용도 가능
~~~R
lapply(split(iris$Sepal.Length, iris$Species), mean)
~~~

18. expand.grid function
- 가능한 모든 level의 factor 조합을 생성
- ntree : 100, 200, 300 / mtry : 1, 2 인 모든 조합을 생성
~~~R
expand.grid(ntree = c(100, 200, 300), mtry = c(1,3))
~~~

19. replicate function
- 첫번째 인자에 반복 횟수를 넣고, 두번째 인자에 반복문의 내용을 넣어주면,  
 return vector 를 생성해주는 함수
- for문을 간단하게 돌려주는 function
- 길이가 100인 1:6 중 한개의 값을 저장하는 vector 생성
~~~r
replicate(100, sample(1:6, 1))
~~~

20. agrep function
- grep 함수와 유사한 기능 제공 -> vector 에서 특정 문자를 찾아주는 것 같음
- 첫번째 인자에 찾고 싶은 word 입력
- 두번째 인자에 vector 입력
~~~r
word  <- "text"
words <- c("hello", "my", "name", "is", "texts", "text")
agrep(word, words) # 해당 문자가 포함된 위치의 idx return
~~~

21. chartr function
- 첫번째와 두번째의 문자를 치환
- ** 구간도 가능 !!
~~~r
line.1 <- "A rat in a trap"
line.2 <- "A B C D E F G H"
line.3 <- "독 안에 든 쥐"

chartr("rat", "cat", line.1)
chartr("A-C", "H-J", line.2)
chartr("독안쥐", "집위말", line.3)
~~~

22. reorder function -> ggplot2에서 응용
- reorder(정렬하고 싶은 변수, 연속형 data)
~~~r
ggplot(data=sw, aes(reorder(노선명, 승차총승객수, sum), 승차총승객수))
~~~

23. findInterval function
- 수치형 변수를 특정 범위를 기준으로 level을 편성해주는 함수
- findInterval(나누고자 하는 수치형 변수(vec), 나누게 되는 기준 변수(vec))
- 다음의 예를 보면 이해하기 편함!
~~~r
x <- c(3, 6, 7, 7, 29, 37, 52)
vec <- c(2, 5, 6, 35)
findInterval(x, vec) 
#>  [1] 1 3 3 3 3 4 4
~~~
- x의 있는 값이 vec 를 기준으로 포함되어 있는 level 을 보여줌

24. interaction function
- 두 백터에 대한 곱(?) 을 의미 함 -> 큰 의미는 없는 함수 인듯 ... 
~~~r
a <- c(1,2,3)
b <- c(3,2,1)
interaction(a,b)
~~~

25. dimnames function
- 행과 열 이름을 한꺼번에 지정해주는 함수
- colnames + rownames
~~~r
x <- matrix(1:9, ncol = 3)
dimnames(x) <- list(c("r1", "r2", "r3"), c("c1", "c2", "c3"))
~~~

26. aperm(array permutation(순열)) function
-  배열의 차원의 순서를 바꿔 배열의 구조를 변경시킴
~~~r
array1  <- array(c(1:24), dim = c(4, 3, 2))
matrix1 <- aperm(array(c(1:24), dim = c(4, 3, 2)), perm = c(2, 1, 3)) # perm : 행, 열, 차원의 순서 
~~~

27. duplicated function
- 중복된 행을 삭제하기 위한 함수
- 중복된 행이 있을 경우, 2번째 중복된 행 부터 TRUE, 그렇지 않으면 FALSE로 결과 값 return
~~~r
test.df <- data.frame(a= c(1,2,3,2,1), b = c(1, 2, 3, 2,1))
duplicated(test.df) # 4, 5번째 행은 중복임을 확인!
~~~

28. merge function
- key 값을 기준으로 결합하는 함수
- ** cbind는 단순히 두개의 data.frame을 합치는 개념이라면, merge 함수는 key 값을 기준으로
inner join을 하는 개념!
~~~r
cust_mart_12 <- data.frame(cust_id = c("c01", "c02", "c03", "c04", "c05", "c06", "c07")
                  , last_name = c("kim", "Lee", "Choi", "Park", "Bae", "Kim", "Lim"))

cust_mart_7  <- data.frame(cust_id = c("c03", "c04", "c05", "c06", "c07", "c08", "c09")
                  , buy_cnt = c(3,1,0,7,3,4,1))


merge(cust_mart_12, cust_mart_7, key = "cust_id", all = T)
~~~

29. ftable function
- 변수에 대한 교차표 생성!
- 특정 dataframe 내에 있는 두개의 범주형 데이터에 대한 교차표를 생성하고 싶을 때,
~~~r
unique(mtcars$vs)
unique(mtcars$gear)
ftable(vs~gear, data = mtcars)
~~~