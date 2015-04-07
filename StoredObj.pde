class StoredObj {
  JSONObject json; 
  //  StoredObj prev;
  Edge[] edges; 
  String address; 
  String thisName;
  String nextName; 

  public StoredObj() {
    json = new JSONObject();
  }

  public StoredObj(String address, String thisName) {
    this.address = address;
    this.thisName = thisName;
    this.nextName = thisName;
    json = loadJSONObject(path+address + "?limit="+edgeLimit);
    JSONArray jsonEdges = json.getJSONArray("edges"); 
    edges = new Edge[jsonEdges.size()];
    for (int i = 0; i < jsonEdges.size (); i++) {
      JSONObject edge = jsonEdges.getJSONObject(i); 
      //JSONArray nodes = edge.getJSONArray("nodes");
      //String s1 = nodes
      String startLemmas = edge.getString("startLemmas"); 
      String endLemmas = edge.getString("endLemmas"); 
      String start = edge.getString("start"); 
      String end = edge.getString("end"); 
      String rel = edge.getString("rel"); 
      boolean newEdgeIsStart;
      if (start.equals(address)) { 
        //println("START MATCH, PICKED END"); 
        newEdgeIsStart = false;
      } else if (end.equals(address)) {
        //println("END MATCH, PICKED START"); 
        newEdgeIsStart = true;
      } else {
        //println("NO MATCH, PICKED DEFAULT (start)");
        newEdgeIsStart = true;
      }
      edges[i] = new Edge(startLemmas, endLemmas, start, end, rel, newEdgeIsStart);
    }
  } 

  public void getNewJSON() {
    //prev = new StoredObj();
    thisName = nextName; 
    //totalString += " " + thisName; 
    int whichEdge = (int)random(edges.length);
    String newEdge = ""; 
    //println("start: " + edges[whichEdge].start + " vs. address: " + address);
    //println("end: " + edges[whichEdge].end + " vs. address: " + address);
    while (!edges[whichEdge].start.contains ("/en/") || !edges[whichEdge].end.contains("/en/") ||
      edges[whichEdge].start.contains ("/n/") || edges[whichEdge].end.contains("/n/") ||
      edges[whichEdge].start.contains ("/v/") || edges[whichEdge].end.contains("/v/") ||
      edges[whichEdge].start.contains ("/a/") || edges[whichEdge].end.contains("/a/") 
      ) {
      whichEdge = (int)random(edges.length);
    }
    if (edges[whichEdge].start.equals(address)) { 
      //println("START MATCH, PICKED END"); 
      newEdge = edges[whichEdge].end;
      nextName = edges[whichEdge].startLemmas;
    } else if (edges[whichEdge].end.equals(address)) {
      //println("END MATCH, PICKED START"); 
      newEdge = edges[whichEdge].start; 
      nextName = edges[whichEdge].endLemmas;
    } else { 
      //println("NO MATCH, PICKED DEFAULT (start)"); 
      newEdge = edges[whichEdge].start;
      nextName = edges[whichEdge].endLemmas;
    }

    address = newEdge;

    println("NEW ADDRESS IS : " + address);
    println("NEW NAME IS : " + nextName);
    json = loadJSONObject(path + address + "?limit=" + edgeLimit); // + "?limit=5");
    JSONArray jsonEdges = json.getJSONArray("edges"); 
    edges = new Edge[jsonEdges.size()];
    for (int i = 0; i < jsonEdges.size (); i++) {
      JSONObject edge = jsonEdges.getJSONObject(i); 
      //JSONArray nodes = edge.getJSONArray("nodes");
      //String s1 = nodes
      String startLemmas = edge.getString("startLemmas"); 
      String endLemmas = edge.getString("endLemmas"); 
      String start = edge.getString("start"); 
      String end = edge.getString("end"); 
      String rel = edge.getString("rel"); 
      boolean newEdgeIsStart;
      if (start.equals(address)) { 
        //println("START MATCH, PICKED END"); 
        newEdgeIsStart = false;
      } else if (end.equals(address)) {
        //println("END MATCH, PICKED START"); 
        newEdgeIsStart = true;
      } else { 
        //println("NO MATCH, PICKED DEFAULT (start)"); 
        newEdgeIsStart = true;
      }
      edges[i] = new Edge(startLemmas, endLemmas, start, end, rel, newEdgeIsStart);
    }
  }

  public void printAllEdges() {
    textSize(40);
    text(thisName, 100, 200); 
    text(nextName, 100, 400); 
    //    for (int i = 0; i < edges.length; i++) {
    //      if(edges[i].isStart == true) {
    //        text(edges[i].startLemmas, 0, 40+i*20);
    //      } else {
    //        text(edges[i].endLemmas, 0, 40+i*20);
    //      } 
    //      text("start " + edges[i].start, 0, 40+ i * 45);
    //      text("end " + edges[i].end, 500, 40+i *45); 
    //      text("rel " + edges[i].rel, 0, 60+i * 45);
    //println("ok " + i);
    //    }
  }


  public void printThisName(float x, float y) {
    textSize(32);
    textAlign(CENTER); 
    text(thisName, x, y); 
    //text(nextName, x, y);
  }
}

