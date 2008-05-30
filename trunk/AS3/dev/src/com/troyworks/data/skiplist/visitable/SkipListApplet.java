import java.awt.*;
import java.awt.event.*;
import java.applet.*;
import java.util.*;
import java.lang.Thread;

// skip list applet
// this is the controller of the skip list and skip list canvas
public class SkipListApplet extends Applet implements Observer {
    SkipListCanvas  slc;
    Button    buildFastButton;
    Button    resetButton;
    Button    buildSlowButton;
    Button    findButton;
    Button    findAllButton;
    TextField findTarget;
    Panel     buttonPanel;
    int       step_state;

    public SkipListApplet() {
        slc = null;
    }
    
    public void init()
	{
	    Label x;
	    
		// applet is border layout
		setLayout(new BorderLayout());
		
		// build the skip list canvas and place it in the center of the applet
		slc = new SkipListCanvas();
        // add the panel to the applet
        add(slc,"Center");
		
		// add all the buttons and their action listeners
		// also add the text field for entering a search target
        buildFastButton = new Button("Build (fast)");
        buildFastButton.addActionListener(new buildFastButtonHandler());
        buildSlowButton = new Button("Build (slow)");
        buildSlowButton.addActionListener(new buildSlowButtonHandler());
        resetButton = new Button("Reset");
        resetButton.addActionListener(new ResetButtonHandler());
        findButton = new Button("find");
        findButton.addActionListener(new FindButtonHandler());
        findTarget = new TextField("1");
        findAllButton = new Button("find all");
        findAllButton.addActionListener(new FindAllButtonHandler());
        buttonPanel = new Panel();
        buttonPanel.setLayout(new GridLayout(1,6));
        buttonPanel.add(buildFastButton);
        buttonPanel.add(buildSlowButton);
        buttonPanel.add(resetButton);
        buttonPanel.add(findButton);
        buttonPanel.add(findTarget);
        buttonPanel.add(findAllButton);
        add(buttonPanel,"North");
        add(new Label(),"South");
        
        // start with only build buttons enabled
        buildFastButton.setEnabled(true);
        buildSlowButton.setEnabled(true);
        resetButton.setEnabled(false);
        findButton.setEnabled(false);
        findTarget.setEnabled(false);
        findAllButton.setEnabled(false);
	}

    // use a fixed data vector
    public Vector getDataVector() {
    		Vector v = new Vector(64);
    		v.addElement(new Integer(10));
    		v.addElement(new Integer(26));
    		v.addElement(new Integer(31));
    		v.addElement(new Integer(3));
    		v.addElement(new Integer(5));
    		v.addElement(new Integer(6));
    		v.addElement(new Integer(23));
    		v.addElement(new Integer(9));
    		v.addElement(new Integer(22));
    		v.addElement(new Integer(4));
    		v.addElement(new Integer(27));
    		v.addElement(new Integer(20));
    		v.addElement(new Integer(21));
    		v.addElement(new Integer(28));
    		v.addElement(new Integer(29));
    		v.addElement(new Integer(2));
    		v.addElement(new Integer(8));
    		v.addElement(new Integer(7));
    		v.addElement(new Integer(25));
    		v.addElement(new Integer(1));
    		v.addElement(new Integer(13));
    		v.addElement(new Integer(15));
    		v.addElement(new Integer(16));
    		v.addElement(new Integer(32));
    		v.addElement(new Integer(14));
    		v.addElement(new Integer(18));
    		v.addElement(new Integer(24));
       		v.addElement(new Integer(19));
    		v.addElement(new Integer(17));
    		v.addElement(new Integer(30));
    		v.addElement(new Integer(12));
    		v.addElement(new Integer(11));
    		
    		return v;
    }

    // called by the skip list canvas when array is finished building
    public void update(Observable o,Object arg) {
        resetButton.setEnabled(true);
        findButton.setEnabled(true);
        findTarget.setEnabled(true);
        findAllButton.setEnabled(true);
    }

	public void start() {
    }
    
    // each of the action listeners following enable or disable
    // the applet buttons and text field as required for their
    // function. everything is disabled when an operation is in progress
    // and appropriate fields are reenabled when an operation completes
    
    // start a fast build
    class buildFastButtonHandler implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            buildFastButton.setEnabled(false);
            buildSlowButton.setEnabled(false);
            resetButton.setEnabled(false);
            findButton.setEnabled(false);
            findTarget.setEnabled(false);
      		Vector v = getDataVector();
       		slc.setData(v);
       		slc.setTimeout(25L);
            slc.build(SkipListApplet.this);
        }
    }
    
    // start a slow build
    class buildSlowButtonHandler implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            buildFastButton.setEnabled(false);
            buildSlowButton.setEnabled(false);
            resetButton.setEnabled(false);
            findButton.setEnabled(false);
            findTarget.setEnabled(false);
      		Vector v = getDataVector();
       		slc.setData(v);
       		slc.setTimeout(150L);
            slc.build(SkipListApplet.this);
        }
    }
    
    // clear for a restart
    class ResetButtonHandler implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            buildFastButton.setEnabled(true);
            buildSlowButton.setEnabled(true);
            resetButton.setEnabled(false);
            findButton.setEnabled(false);
            findTarget.setEnabled(false);
            findAllButton.setEnabled(false);
            step_state = 0;
        }
    }
    
    // get find target and execute a single find operation
    class FindButtonHandler implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            String s;
            int    i;
            // get the current value of the find target text field
            s = findTarget.getText();
            try {
                i = Integer.valueOf(s).intValue();
                if ((i < SkipNode.MinNodeValue)||(SkipNode.MaxNodeValue < i)) {
                    findTarget.setText("range");
                }
                else {
                    buildFastButton.setEnabled(false);
                    buildSlowButton.setEnabled(false);
                    resetButton.setEnabled(false);
                    findButton.setEnabled(false);
                    findTarget.setEnabled(false);
                    slc.find(SkipListApplet.this,i);
                }
            } catch (NumberFormatException ex) {
                findTarget.setText("error");
            }
        }
    }

    // execute a find all operation
    class FindAllButtonHandler implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            buildFastButton.setEnabled(false);
            buildSlowButton.setEnabled(false);
            resetButton.setEnabled(false);
            findButton.setEnabled(false);
            findTarget.setEnabled(false);
            slc.findAll(SkipListApplet.this);
        }
    }
}
