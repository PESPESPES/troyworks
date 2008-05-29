import java.awt.*;
import java.awt.event.*;
import java.applet.*;
import java.util.*;
import java.lang.Thread.*;

// SkipListCanvas
// this is the view that displays the structure and operations
// of the skip list algorithm. it has a skip list data structure
// attached as the model
public class SkipListCanvas extends Canvas implements Observer {
    // operation codes
    public static final int BUILD   = 0;
    public static final int FIND    = 1;
    public static final int FINDALL = 2;
    
    private SkipList    SkipX;
    private Thread      BuildThread;
    private long        StepTimeout;
    private boolean     LastUpdate;
    private FinishBuild Finished;
    private Stepper     Stpr;
    private String      Progress;
    private boolean     Busy;
    private SkipList    CurrentList;
    private int         column;
    private Vector      CurrentData;
    private int         Operation;
    private int         Target;
    private String      FindResult;
    private Vector      PointVector;
    
    public SkipListCanvas() {
        PointVector = new Vector(64);
        SkipX       = null;
        BuildThread = null;
        StepTimeout = 0;
        LastUpdate  = false;
        Finished    = null;
        Stpr        = new Stepper();
        Progress    = "";
        Busy        = false;;
        CurrentList = null;
        column      = 0;
        Operation   = 0; // build
        Target      = SkipNode.MaxNodeValue + 1;
        FindResult  = "";
    }
    

    // get a copy of the current data set
    public synchronized Vector getData() {
        return CurrentData;
    }

    // set the current data set to a new set of values
    public synchronized void setData(Vector v) {
        CurrentData = (Vector)v.clone();
    }
    
	public void build() {
	    Vector v    = getData();
	    int    maxH = 10;
	    
	    // not finding
        FindResult = "";
	    
	    // get data vector and quit if it is empty
	    Enumeration e = v.elements();
	    
	    // insert all elements in the data vector into the tree
        SkipX = new SkipList(0.4,maxH,this); // tail element is largest value allowed
        
        while (e.hasMoreElements()) {
       	    // clear all node marks
       	    SkipX.clearVisited();
            // clear operations count
            SkipX.setOperations(0);
            // insert the next value
            SkipX.insert(((Integer)e.nextElement()).intValue());
        }
        
        // clear operations count
        SkipX.setOperations(0);
        
        // signal no more elements
        SkipX.insert(SkipNode.MinNodeValue-1);
    }

   	public void find() {
   	    int result;
   	    
   	    FindResult = "";
   	    
   	    // clear all 
   	    SkipX.clearVisited();
   	    
   	    // clear operations count
   	    SkipX.setOperations(0);
   	    // find the target value and set a result string
   	    result = SkipX.find(Target);
   	    if (result != Target) {
   	        FindResult = "Search Target Not Found";
   	    }
   	    else {
   	        FindResult = "Search Target Found";
   	    }
        repaint();
    }

    // find all elements
   	public void findAll() {
   	    int    result;
   	    int    t;
   	    int    count;
   	    
   	    FindResult = "";
	    
	    // get data vector and quit if it is empty
	    Enumeration e = SkipX.elements();
	    
        // clear operations count
        SkipX.setOperations(0);
        setTimeout(50L);
        count = 0;
        while (e.hasMoreElements()) {
            // find the next value
            SkipX.clearVisited();
            t = ((Integer)e.nextElement()).intValue();
       	    result = SkipX.find(t);
       	    if (result != t) {
       	        System.out.println("error : findAll item not found!");
       	    }
       	    count++;
        }
        
        // display the average complexity
        FindResult = "Average Ops Per Element : " + Integer.toString(SkipX.getOperations() / count);
        repaint();
    }

    // set the step timeout
    public void setTimeout(long t) {
        StepTimeout = t;
    }
    
    // get the step timeout
    public long getTimeout() {
        return StepTimeout;
    }
    
    // no thread
    public void clrThread() {
        BuildThread = null;
    }

    
    // flag for signalling algorithm is complete
    public void setLastUpdate(boolean b) {
        LastUpdate = b;
    }
    
    public boolean getLastUpdate() {
        return LastUpdate;
    }

    // builder thread builds the tree data structure in the background
    // this allows other user interface updates while it is being built
    // rather than having to wait.
    class Builder extends Thread {
        public void run() {
            // execute the operation specified
            switch(Operation) {
                case SkipListCanvas.BUILD:
                    build();
                    break;
                case SkipListCanvas.FIND:
                    find();
                    break;
                case SkipListCanvas.FINDALL:
                    findAll();
                    break;
                default:
                    break;
            }
            
            // when done, mark thread not used
            clrThread();
            
            // signal finished
            Finished.signalDone();
        }
    }

    // signal that an algorithm is complete
    class FinishBuild extends Observable {
        public void signalDone() {
            setChanged();
            notifyObservers();
        }
    }
    
    // start the thread running with a build operation
    public synchronized void build(Observer o) {
        // set operation to 'build'
        Operation = SkipListCanvas.BUILD;
        Target    = SkipNode.MaxNodeValue + 1;
        
        // set up an observable to signal finished
        Finished = new FinishBuild();
        Finished.addObserver(o);
        
        // run the builder thread
        if (BuildThread == null) {
            BuildThread = new Builder();
            BuildThread.start();
        }
    }
    
    // start the thread running with a find operation
    public synchronized void find(Observer o,int t) {
        // set operation to 'find'
        Operation = SkipListCanvas.FIND;
        Target    = t;
        
        // set up an observable to signal finished
        Finished = new FinishBuild();
        Finished.addObserver(o);
        
        // run the builder thread
        if (BuildThread == null) {
            setTimeout(250L);
            BuildThread = new Builder();
            BuildThread.start();
        }
    }
    
    // start the thread running with a find all operation
    public synchronized void findAll(Observer o) {
        // set operation to 'find'
        Operation = SkipListCanvas.FINDALL;
        
        // set up an observable to signal finished
        Finished = new FinishBuild();
        Finished.addObserver(o);
        
        // run the builder thread
        if (BuildThread == null) {
            setTimeout(50L);
            BuildThread = new Builder();
            BuildThread.start();
        }
    }
    
    // execute a reset
    public synchronized void reset() {
        // run the builder thread
        if (BuildThread == null) {
            setTimeout(0);
            BuildThread = new Builder();
            BuildThread.start();
        }
    }
    
    // allow steps
    public boolean step() {
        // signal
        Stpr.signalStep();
        return getLastUpdate();
    }

    // mutual exclusion to step the builder thread
    class Stepper {
        boolean s;
        
        public Stepper() {
            s = false;
        }
        
        public synchronized void waitStep() {
            try {
                if (getTimeout() == 0) {
                    // wait until signaled
                    while(s == false) {
                        wait();
                    }
                    s = false;
                }
                else {
                    java.lang.Thread.sleep(getTimeout());
                }
            } catch (InterruptedException e) {
            }
        }
        
        // signal one step to whoever is waiting
        public synchronized void signalStep() {
            s = true;
            notifyAll();
        }
    }
    
    // generates the diagram as the skip list is traversed
    public class GraphicSkipListVisitor implements SkipListVisitor {
        Graphics gX;
        int      maxHeight;
        SkipNode head;
        Point    headp;
        
        public GraphicSkipListVisitor(Graphics g,int mh) {
            gX = g;
            maxHeight = mh;
        }
        
        // draw the head node
        private void drawHead(Graphics g,SkipNode n,int mh,int x,int y,int xInc,int yInc,int dy) {
            int yt;
            Color z;
            
            g.setColor(Color.black);
            g.drawString("h",x,y);
            y+= yInc;
            for(int i=1;i<maxHeight;i++) {
                yt = y+(dy / 2);
                // intermediate node
                g.setColor(Color.black);
                g.drawLine(x,yt,x + xInc,yt);
                if (n.getVisited(i)) {
                    // node was used, mark it and remember it
                    z = Color.yellow;
                    PointVector.addElement(new Point(x+(xInc/4),yt));
                }
                else {
                    z = Color.red;
                }
                g.setColor(z);
                g.fillRect(x,y,xInc / 2,dy);
                y += yInc;
            }
        }
        
        // draw the tail node
        private void drawTail(Graphics g,SkipNode n,int mh,int x,int y,int xInc,int yInc,int dy) {
            int yt;
            
            // at the tail 
            g.setColor(Color.blue);
            g.drawString("t",x,y);
            y+= yInc;
            for(int i=1;i<mh;i++) {
                // fill to max height
                yt = y+(dy / 2);
                g.fillRect(x,y,xInc / 2,dy);
                y += yInc;
            }
        }
        
        // draw a data node
        private void drawNode(Graphics g,SkipNode n,int key,int mh,int x,int y,int xInc,int yInc,int dy) {
            int yt;
            Color z;
            g.setColor(Color.black);
            g.drawString(Integer.toString(key),x,y);
            y+= yInc;
            for(int i=1;i<maxHeight;i++) {
                yt = y+(dy / 2);
                g.setColor(Color.black);
                g.drawLine(x,yt,x+xInc,yt);
                if (i <= n.getHgt()) {
                    if (n.getVisited(i)) {
                        // node was used, mark it and remember it
                        z = Color.green;
                        PointVector.addElement(new Point(x+(xInc/4),yt));
                    }
                    else {
                        z = Color.black;
                    }
                    g.setColor(z);
                    g.fillRect(x,y,xInc / 2,dy);
                }
                y += yInc;
            }
        }
        
        // skip list calls this each time a node is visited
        // in any of the skip list algorithm operations
        public void visit(SkipNode n) {
            int xInc = 18;
            int yInc = 16;
            int x   = (column * xInc) + 2;
            int y   = yInc;
            int dy  = (yInc / 2);
            boolean atTail = false;
            Color rectColor;
            
            if (n.getKey() > SkipNode.MaxNodeValue) {
                // at the tail 
                drawTail(gX,n,maxHeight,x,y,xInc,yInc,dy);
                column++;
            }
            else if (n.getKey() < SkipNode.MinNodeValue) {
                // at the head 
                // remember the head
                drawHead(gX,n,maxHeight,x,y,xInc,yInc,dy);
                column++;
            }
            else {
                // at a node
                // draw the node
                drawNode(gX,n,n.getKey(),maxHeight,x,y,xInc,yInc,dy);
                column++;
            }
        }
    }

    // sort vector of points in descending order of y
    // shell sort : fast and stable
    private void sortY(Vector a) {
        int h;
        int l = 0;
        int r = a.size() - 1;
        for(h=1;h<=(r-l)/9;h=3*h+1);
        for(;h > 0;h /= 3) {
            for(int i=l+h;i<=r;i++) {
                int j = i;
                Point p = (Point)a.elementAt(i);
                while((j>=l+h)&&(p.y > ((Point)a.elementAt(j-h)).y)) {
                    a.setElementAt(a.elementAt(j-h),j);
                    j -= h;
                }
                a.setElementAt(p,j);
            }
        }
    }

    // sort vector of points in ascending order of x
    // shell sort : fast and stable
    private void sortX(Vector a) {
        int h;
        int l = 0;
        int r = a.size() - 1;
        for(h=1;h<=(r-l)/9;h=3*h+1);
        for(;h > 0;h /= 3) {
            for(int i=l+h;i<=r;i++) {
                int j = i;
                Point p = (Point)a.elementAt(i);
                while((j>=l+h)&&(p.x < ((Point)a.elementAt(j-h)).x)) {
                    a.setElementAt(a.elementAt(j-h),j);
                    j -= h;
                }
                a.setElementAt(p,j);
            }
        }
    }

    // connect all the visited nodes to show the search path
    private void DrawSearchPath(Graphics g,Vector v) {
        Point  p1;
        Point  p2;

        // nothing if less than 2 elements
        if (v.size() <= 1) {
            return;
        }
        
        // sort in descending order of y
        sortY(v);
        // sort in ascending order of x
        sortX(v);
        // draw the line
        g.setColor(Color.magenta);
        for(int i=0;i<v.size()-1;i++) {
            p1 = (Point)v.elementAt(i);
            p2 = (Point)v.elementAt(i+1);
            g.drawLine(p1.x,p1.y,p2.x,p2.y);
            }
    }
    
    // don't clear the background to avoid flashing
    public void update(Graphics g) {
        g.setColor(getForeground());
        paint(g);
    }

    // repaint the entire image offline and blit it 
    public void paint(Graphics g) {
        Dimension d = getSize();
        Image     memImage = createImage(d.width,d.height);
        Graphics  memG     = memImage.getGraphics();
        Point     p;
        
        if ((CurrentList != null)&&(!Busy)) {
            memG.drawString("Input Data : " + getData().toString()                   ,1,d.height - 5);
            memG.drawString("Operations : " + Integer.toString(SkipX.getOperations()),1,d.height - 20);
            memG.drawString(Progress                                                 ,1,d.height - 35);
            memG.drawString(FindResult                                               ,1,d.height - 50);
            
            column = 0;
            PointVector.removeAllElements();
            // traverse the list, which generates
            // calls to the skip list visitor
            CurrentList.traverse(new GraphicSkipListVisitor(memG,CurrentList.getMaxHeight()));
            
            // now draw a colored line from the point vector array
            DrawSearchPath(memG,PointVector);
            
            // manually dispose the memory graphics context
            memG.dispose();
            
            // blit the image
            g.drawImage(memImage,0,0,this);
            
            // manually flush resources used by the image
            memImage.flush();
        }
    }

    // when the data structure signals a change, force a repaint
    // with the proper data
    public void update(Observable o,Object arg) {
        if (arg == null) {
            setLastUpdate(true);
        }
        else {
            // done
            setLastUpdate(false);
        }
        
        if (arg instanceof String) {
            Progress = (String)arg;
        }
        else {
            Progress = "Finished";
        }
        
        // mark Busy, no repaints while Busy
        Busy = true;
        
        // get a copy of the skip list
        CurrentList = (SkipList)o;
        
        // not Busy anymore
        Busy    = false;
        
        // force a repaint
        repaint();
        
        // wait for user to observe results
        Stpr.waitStep();
    }
}


        
