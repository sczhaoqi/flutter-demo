class Msg<T> {
  int code;
  T data;
  String msg;

  Msg();

  Msg.full(this.code, this.data, this.msg);

}
enum StatusCode {
  OK, //1
  WARN, //2
  FAILED, //3
  ERROR //4
}