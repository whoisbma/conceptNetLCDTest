class Edge { 
  //features
  public String startLemmas; //i.e. name of this edge
  public String endLemmas;
  public String start; //i.e. path to this edge, e.g. /c/en/nose //MAYBE!
  public String end; 
  //public String surfaceText; //the sentence connecting the edge to the node //can't find this in the object for some reason 
  public String rel; //language independent relations
  public boolean isStart = true;
  public Edge(String startLemmas, String endLemmas, String start, String end, String rel, boolean isStart) {
    this.startLemmas = startLemmas;
    this.endLemmas = endLemmas;
    this.start = start;
    this.end = end; 
    //this.surfaceText = surfaceText; //CAN'T FIND IN JSON OBJECT??
    this.rel = rel;
    this.isStart = isStart;
  } 

  public void findEdgeName() {
  }
} 
