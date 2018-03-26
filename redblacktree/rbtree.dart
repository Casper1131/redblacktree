import 'treebase.dart';

import 'node.dart';
class RBTree<T> extends TreeBase<T>{
    Node<T> root;
    Function _comparator;
    int size;
    RBTree(
      int comparator(T a,T b)
      ) : super(comparator) {
        this._comparator = comparator;
        this.size = 0;
      }
      bool insert(
        T data
        ){
          bool ret = false;
          if(this.root == null){
            this.root = new Node<T>(data);
            ret = true;
            this.size++;
          }
          else{
            Node<T> head = new Node<T>(null);
            bool dir = false;
            bool last = false;
            Node<T> gp = null;
            Node<T> ggp = head;
            Node<T> p = null;
            Node<T> node = this.root;
            ggp.right = this.root;
            while(true){
              if(node == null){
                node = new Node<T>(data);
                p.set_child(dir, node);
                ret = true;
                this.size++;
              }
              else if(this.is_red(node.left)&&this.is_red(node.right))
              {
                node.red = true;
                node.left.red = false;
                node.right.red = false;
              }
              if(this.is_red(node)&&this.is_red(p)){
                bool dir2 = ggp.right == gp;
                if(node == p.get_child(last)){
                  ggp.set_child(dir2, this.single_rotate(gp, !last));
                }
                else{
                  ggp.set_child(dir2, this.double_rotate(gp, !last));
                }
              }
              int cmp = this._comparator(node.data,data);
              if(cmp == 0){
                break;
              }
              last = dir;
              dir = cmp < 0;
              if(gp != null){
                ggp = gp;
              }
              gp = p;
              p = node;
              node = node.get_child(dir);
            }
            this.root = head.right;
          }
          this.root.red = false;
          return ret;
        }
  bool remove(
    T data
  ){
    if(this.root == null){
      return false;
    }
    Node<T> head = new Node<T>(null);
    Node<T> node = head;
    node.right = this.root;
    Node<T> p = null;
    Node<T> gp = null;
    Node<T> found = null;
    bool dir;
    dir = true;
    while(node.get_child(dir)!=null){
      bool last;
      last = dir;
      gp = p;
      p = node;
      node = node.get_child(dir);
      int cmp = this._comparator(data,node.data);
      dir = cmp > 0;
      if(cmp == 0){
        found = node;
      }
      if(!this.is_red(node)&&!this.is_red(node.get_child(dir))){
        if(this.is_red(node.get_child(!dir))){
          Node sr = this.single_rotate(root, dir);
          p.set_child(dir, sr);
          p = sr;
        }
        else if(!this.is_red(node.get_child(!dir))){
          Node sibling = p.get_child(!last);
          if(sibling != null){
            if(!this.is_red(sibling.get_child(!last))&&this.is_red(sibling.get_child(last))){
              p.red = false;
              sibling.red = true;
              node.red = true;
            }
            else{
              bool dir2 = gp.right == p;
              if(this.is_red(sibling.get_child(last))){
                gp.set_child(dir2, this.double_rotate(p, last));
              }
              else if(this.is_red(sibling.get_child(!last))){
                gp.set_child(dir2, single_rotate(p, last));
              }
              Node gpc = gp.get_child(dir2);
              gpc.red  = true;
              node.red = true;
              gpc.left.red = false;
              gpc.right.red = false;
            }
          }
        }
      }
    }
    if(found !=null){
      found.data = node.data;
      p.set_child(p.right == node, node.get_child(node.left == null));
      this.size--;
    }
    this.root = head.right;
    if(this.root != null){
      this.root.red = false;
    }
    return found !=null;
  }
  bool is_red(node){
    return node !=null && node.red;
  }
  Node single_rotate(
    Node root,
    bool dir
  ){
    Node save = root.get_child(!dir);
    root.set_child(!dir, save.get_child(dir));
    save.set_child(dir, root);
    root.red = true;
    save.red = false;
    return save;
  }
  Node double_rotate(
    Node<T> root,
    bool dir
  ){
    root.set_child(!dir,this.single_rotate(root.get_child(!dir), !dir));
    return single_rotate(root,dir);
  }
}