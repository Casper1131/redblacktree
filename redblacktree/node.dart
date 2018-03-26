class Node<T>{
  T data;
  Node left;
  Node right;
  bool red;
  Node(
    T data
  ){
    this.right = null;
    this.left = null;
    this.data = data;
    this.red = true;
  }
  Node get_child(
    bool dir
    ){
    return dir ? this.right : this.left;
  }
  void set_child(
    bool dir,
    Node value
  ){
    if(dir){
      this.right = value;
    }
    else{
      this.left = value;
    }
  }
}