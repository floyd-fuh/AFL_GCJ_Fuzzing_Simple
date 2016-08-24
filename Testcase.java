import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
public class Testcase{
    public native void nativeCrash();
    public static void main(String args[]){
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        try{
            String s = in.readLine();
            if(s == null || s.length() == 0){
                System.out.println("Hum?");
                System.exit(1);
            }
            if(s.charAt(0) == '0'){
                System.out.println("Looks like a zero to me!");
	          	//System.exit(134); //Doesn't work, although it looks "the same" in a bash $?, it's not the same, therefore: 
	                new Testcase().nativeCrash();
            }
            else{
                System.out.println("A non-zero value? How quaint!");
            }
            System.exit(0);
        }
        catch(IOException ioe){
            System.out.println("Hum?");
            System.exit(1);
        }
    }
}
