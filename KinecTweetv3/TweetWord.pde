class TweetWord {
  
  String status; String name;

  TweetWord(String n, String s){
    status = s;
    name = n;
  }
  // a method to concatenate name and status
  String getText(){
    return "@" + name + ": " + status;
  }

}
