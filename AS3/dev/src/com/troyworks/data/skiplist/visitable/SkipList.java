import java.util.*;

// implement the skip list with an integer key/object
// and implement the hooks to fire changes to the view
public class SkipList extends Observable {
    private SkipNode        head;
    private SkipNode        tail;
    private double          probability;
    private int             maxHeight;
    private int             curHeight;
    private RandomHeight    randGen;
    private int             operations;
    
    public SkipList(double p, int m,Observer o) {
        curHeight   = 1;
        maxHeight   = m;
        probability = p;
        randGen     = new RandomHeight(m,p);
        operations  = 0;

        // Create head and tail and attach them
        head = new SkipNode(maxHeight);
        tail = new SkipNode(SkipNode.MaxNodeValue + 1,maxHeight);
        for ( int x = 1; x <= maxHeight; x++ ) {
            head.setFwdNode(x,tail);
        }
        
        // add the observer if there is one
        if (o != null) {
            addObserver(o);
        }
    }
    
    public void setOperations(int ops) {
        operations = ops;
    }
    
    public int getOperations() {
        return operations;
    }
    
    public void incOperations() {
        operations++;
    }
    
    // insert an element
    public boolean insert(int k) {
        int        lvl = 0;
        int        h = 0;
        SkipNode[] updateVec = new SkipNode[maxHeight+1];
        SkipNode   tmp = head;
        int        cmpKey;
        String     s = "Inserting : " + Integer.toString(k);
        
        if (k < SkipNode.MinNodeValue) {
            // last update
            setChanged();
            notifyObservers(null);
            return false;
        }

        // Figure out where new node goes
        for ( h = curHeight; h >= 1; h-- ) {
            incOperations();
            tmp.setVisited(h,true);
            update(s);
            
            cmpKey = tmp.getFwdNode(h).getKey();
            while ( cmpKey < k ) {
                tmp    = tmp.getFwdNode(h);
                
                // print current view
                incOperations();
                tmp.setVisited(h,true);
                update(s);
                
                cmpKey = tmp.getFwdNode(h).getKey();
            }
            updateVec[h] = tmp;
        }
        tmp    = tmp.getFwdNode(1);
        cmpKey = tmp.getKey();

        // If dup, return false
        if ( cmpKey == k ) {
            return false;
        }
        else {
            // Perform an insert
            lvl = randGen.newLevel();
            if ( lvl > curHeight ) {
                for ( int i = curHeight + 1; i <= lvl; i++ ) {
                    incOperations();
                    updateVec[i] = head;
                }
                curHeight = lvl;
            }
        }
          
        // Insert new element
        tmp = new SkipNode(k,lvl);
        for ( int i = 1; i <= lvl; i++ ) {
            // print current view
            incOperations();
            tmp.setVisited(h,true);
            update(s);
            
            tmp.setFwdNode(i,updateVec[i].getFwdNode(i));
            updateVec[i].setFwdNode(i,tmp);
        }
        
        // signal new node inserted
        tmp.setVisited(h,true);
        update(s);
        
        return true;
    }

    // signal that the model changed
    private void update(String arg) {
        setChanged();
        notifyObservers(arg);
    }

    public SkipNode getHead() {
        return head;
    }
    
    public SkipNode getTail() {
        return tail;
    }

    public int getMaxHeight() {
        return maxHeight;
    }
    
    // execute a find operation
    public int find(int key)  {
        int h = 0;
        SkipNode   tmp       = head;
        SkipNode   x;
        int        cmpKey;
        int        result;
        int        findIndex = 1;
        String     s = "Finding : " + Integer.toString(key);

        // Find the key and return the node
        for ( h = curHeight; h >= 1; h-- ) {
            incOperations();
            // print current view
            tmp.setVisited(h,true);
            update(s);
            // look ahead at current list height to next key
            cmpKey = tmp.getFwdNode(h).getKey();
            // if next key is less than this key then that's too far
            // descend the list of forward nodes to find one that is not too far
            while ( cmpKey < key ) {
                incOperations();
                
                tmp    = tmp.getFwdNode(h);
                
                // print current view
                tmp.setVisited(h,true);
                update(s);
                
                // look at next key
                cmpKey = tmp.getFwdNode(h).getKey();
            }
            // stop when keys are equal
            if (cmpKey == key) {
                findIndex = h;
                break;
            }
        }
        
        incOperations();
        
        tmp = tmp.getFwdNode(findIndex);
        cmpKey = tmp.getKey();

        tmp.setVisited(h,true);
        update(s);
        if ( cmpKey == key ) {
            result = key;
        }
        else {
            result = SkipNode.MinNodeValue - 1;
        }
        return result;
    }
    
    // traverse the skip list at the '1' level as a linked list
    public void traverse(SkipListVisitor v) {
        SkipNode tmp;
        int      k;

        tmp = head;
        while ( tmp != tail ) {
            // visit the node
            v.visit(tmp);
            // next node
            tmp = tmp.getFwdNode(1);
        }
        v.visit(tail);
    }
    
    // mark all nodes 'not visited'
    public void clearVisited() {
        SkipNode tmp;
        
        tmp = head;
        while(tmp.getKey() <= SkipNode.MaxNodeValue) {
            tmp.clearVisited();
            tmp = tmp.getFwdNode(1);
        }
    }

    // implement an enumerator for the skip list
    public Enumeration elements() {
        return new SkipListEnumeration();
    }
        

    // traverse at level 1 as a linked list
    class SkipListEnumeration implements Enumeration {
        private SkipNode next;
        
        public SkipListEnumeration() {
            next = head.getFwdNode(1);
        }
        
        public boolean hasMoreElements() {
            boolean result;
            if (next.getKey() <= SkipNode.MaxNodeValue) {
                result = true;
            }
            else {
                result = false;
            }
            return result;
        }
        
        public Object nextElement() {
            Integer i;
            
            i = new Integer(next.getKey());
            next = next.getFwdNode(1);
            
            return i;
        }
    }
    
    
    // test function
    public void dump()
    {
        traverse(new SkipListPrintVisitor());
    }

    // test function
    class SkipListPrintVisitor implements SkipListVisitor {
        public void visit(SkipNode n) {
            int k;
            
            // print the Key
            k = n.getKey();
            
            if (k < 0) {
                System.out.print("h");
            }
            else {
                System.out.print(n.getKey());
            }
            // print nodes
            for(int i=0;i<maxHeight;i++) {
                if (i > n.getHgt()) {
                    System.out.print(".");
                }
                else {
                    System.out.print("v");
                }
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        SkipList sl = new SkipList(0.5,4,null);
        sl.insert(1);
        sl.insert(9);
        sl.insert(8);
        sl.insert(3);
        sl.insert(5);
        sl.insert(2);
        sl.insert(4);
        sl.insert(7);
        sl.insert(6);
        
        sl.dump();

    }
}


