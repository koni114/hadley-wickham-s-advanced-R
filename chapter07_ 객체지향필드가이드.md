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





### 퀴즈 풀기
* 객체가 관련되어 있는 OO 시스템이 무엇인지 어떻게 알 수 있는가?
* 객체의 base type을 어떻게 판단하는가?
* 제너릭 함수는 무엇인가?
* S3와 S4의 주요 차이는 무엇인가? 그리고 S4와 RC의 주된 차이는 무엇인가?
