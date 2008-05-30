// implement a node in the skip list
public class SkipNode {
    private int        nodeHeight;
    private int        key;
    private SkipNode[] fwdNodes;
    private boolean[]  visited;
    
    public static final int MaxNodeValue = 65536;
    public static final int MinNodeValue = 0;
    
      //  friend class SkipList;
    public SkipNode(int k,int h) {
        nodeHeight = h;
        key        = k;
        fwdNodes   = new SkipNode[h+1];
        visited    = new boolean[h+1];
        for (int x = 1; x <= nodeHeight; x++) {
          fwdNodes[x] = null;
          visited[x]  = false;
        }
    }
        
    public SkipNode(int h) {
        nodeHeight = h;
        key        = MinNodeValue - 1; // -1 means not populated
        fwdNodes   = new SkipNode[h+1];
        visited    = new boolean[h+1];
        for (int x = 1; x <= nodeHeight; x++) {
          fwdNodes[x] = null;
          visited[x]  = false;
        }
    }    

    public int getKey() {
        return key;
    }
    
    public int getHgt() {
        return nodeHeight;
    }
    
    public void setFwdNode(int i,SkipNode x) {
        fwdNodes[i] = x;
    }
    
    public SkipNode getFwdNode(int i) {
        return fwdNodes[i];
    }
    
    public void setVisited(int i,boolean b) {
        visited[i] = b;
    }
    
    public boolean getVisited(int i) {
        return visited[i];
    }
    
    public void clearVisited() {
        for(int i=0;i<nodeHeight+1;i++) {
            visited[i] = false;
        }
    }
}
