/*
Developed under a Research grant from NMEICT, MHRD 
by 
Amrita CREATE (Center for Research in Advanced Technologies for Education), 
VALUE (Virtual Amrita Laboratories Universalizing Education)
Amrita University, India 2009 - 2013
http://www.amrita.edu/create
*/
package objects {
 
      import flash.display.Sprite;
	  import flash.display.DisplayObject;
      import flash.geom.Point;
      import flash.text.*;
      
      import flash.net.URLRequest;
      import flash.display.Loader;
      import org.papervision3d.core.geom.*;
      import org.papervision3d.core.geom.renderables.*;      
      import org.papervision3d.core.geom.Lines3D;
      import org.papervision3d.core.geom.renderables.Line3D;
      import org.papervision3d.core.geom.renderables.Vertex3D;
      import org.papervision3d.materials.WireframeMaterial;
      import org.papervision3d.materials.special.LineMaterial;
      import org.papervision3d.objects.DisplayObject3D;
      import org.papervision3d.objects.primitives.Cylinder;
	  import org.papervision3d.objects.primitives.Sphere;
      import org.papervision3d.materials.special.CompositeMaterial;
	  import org.papervision3d.materials.ColorMaterial;
	  import org.papervision3d.lights.PointLight3D;
	  import org.papervision3d.materials.shadematerials.CellMaterial;     
      
      

      public class PendBar extends DisplayObject3D {

      private var sprite:Sprite;
      private var myLength:Number;
      private var pendLine:Lines3D;
	  private var discIndicator:Lines3D;
      private var ballMaterial:WireframeMaterial;
      private var mypendBar:Cylinder;
	  private var mypendBar1:Cylinder;
	  private var mypendBar2:Cylinder;
	  private var composite:CompositeMaterial;
	  private var composite1:CompositeMaterial;
	  private var color1:ColorMaterial;
	  private var cell:CellMaterial;
	  private var light:PointLight3D;
      private var sphere1:Sphere;
	  private var sphere2:Sphere;
	  private var line:Line3D;
      public function PendBar(myLength:Number,flag:Number=0,slderVal:Number=10,discRadiusFlag:Number=0,stringFlag:Number=0) {
      this.myLength=myLength;
      init(flag,slderVal,discRadiusFlag,stringFlag);
	  }

      private function init(flag:Number,slderVal:Number,discRadiusFlag:Number=200,stringFlag:Number=0):void {
      ballMaterial = new WireframeMaterial(0,0,.5);
	  
	 
	 pendLine = new Lines3D(new LineMaterial(0xCCCCCC)); 
	  var topVert:Vertex3D = new Vertex3D(0,0,0);
	  var btmVert:Vertex3D = new Vertex3D(0,myLength,0);
	  if(stringFlag==0)
	  {
     	   line = new Line3D(pendLine, new LineMaterial(0x555588) , 2, topVert, btmVert);

	  }
	  if(stringFlag==1)
	  {
     	  line = new Line3D(pendLine, new LineMaterial(0x9EB34D) , 2, topVert, btmVert);

	  }
	  if(stringFlag==2)
	  {
     	 line = new Line3D(pendLine, new LineMaterial(0xC65353) , 2, topVert, btmVert);

	  }
	 // var line:Line3D = new Line3D(pendLine, new LineMaterial(0x2D899F) , 2, topVert, btmVert);
	  pendLine.addLine(line);	
      addChild(pendLine);      
	if(flag==0)
	 {		
	 var check1:DisplayObject3D=new DisplayObject3D();	 
	 composite= metalCharacteristic(0x9FBBF9,0x67B3FE,0x0263C1)
	 	 mypendBar= new Cylinder(composite, slderVal,300 , 15, 10);
		  mypendBar.y=myLength+50;
		//  mypendBar1.y=myLength+100;
		 mypendBar.rotationZ=90;
		 pendLine.addChild(mypendBar);
	 }
	  if(flag==1)
	 {
		  discIndicator=new Lines3D(randMat1());
		  composite= metalCharacteristic(0x398D1D,0x7AD852,0x234E10);
			mypendBar= new Cylinder(composite, discRadiusFlag, slderVal, 15, 5);
			mypendBar.y=myLength+10;
			var topVertIndi:Vertex3D = new Vertex3D(-10,720,0);
			var btmVertIndi:Vertex3D = new Vertex3D(-200,720,0);
			var lineIndicator:Line3D = new Line3D(discIndicator, randMat1() , 5, topVertIndi, btmVertIndi);		
			discIndicator.addLine(lineIndicator);
			discIndicator.rotationY=270;
				//discIndicator.rotationY=270;
		  	pendLine.addChild(discIndicator);
			pendLine.addChild(mypendBar);
	 }
	// trace(flag);
	 if(flag==2)
	 {		
	 	 check1=new DisplayObject3D();	
		 composite= metalCharacteristic(0x940505,0xFA8D8D,0x940505)
	 	 mypendBar= new Cylinder(composite,30,slderVal , 10, 5);
		 composite= metalCharacteristic(0x940505,0xFA8D8D,0x940505)
		 mypendBar1= new Cylinder(composite, 80,discRadiusFlag , 10, 5);
		 mypendBar2= new Cylinder(composite, 80,discRadiusFlag , 10, 5);
		 mypendBar.y=myLength+30;
		 mypendBar1.y=myLength+20;
		  mypendBar2.y=myLength+20;
		//trace(slderVal);
		 mypendBar1.x=(155*slderVal)/280;///10+10;
		  mypendBar2.x=-(155*slderVal)/280;///10+10;
		 mypendBar.rotationZ=90;
		 mypendBar1.rotationZ=90;
		 mypendBar2.rotationZ=90;
		 check1.addChild(mypendBar1);
		 check1.addChild(mypendBar2);
		 check1.addChild(mypendBar);
		 pendLine.addChild(check1);
		 
	 }
      pendLine.rotationZ=180;     
      
      }   
      
      public function getPin(myRot:Number):Point
		{
			var angle:Number = myRot* Math.PI / 180;			
			var xPos:Number = this.x + Math.sin(angle) * myLength;
			var yPos:Number = this.y - Math.cos(angle) * myLength;			
			return new Point(xPos, yPos);
		}      
      //public function myPin      
      private function randVert():Vertex3D {
      return new Vertex3D(randNum(),randNum(),randNum());
      }
       
      private function randMat():LineMaterial {
      return new LineMaterial(color());
      }
  	private function randMat1():LineMaterial {
      return new LineMaterial(color2());
      }
      private function color():Number {
      //return Math.floor((Math.random() * 0xFFFF00));
	        return (0xCCCCCC);

      }
	  private function color2():Number {
      //return Math.floor((Math.random() * 0xFFFF00));
	        return (0x000000);

      }
      private function randNum():Number {
      return 800 - (Math.random() * 1600);
  
      }
	  private function metalCharacteristic(col1:Number,col2:Number,col3:Number):CompositeMaterial
	  {
		 var color1:ColorMaterial = new ColorMaterial(col1);
		var composite1:CompositeMaterial = new CompositeMaterial();
		composite1.addMaterial(color1);		 
		composite1.addMaterial(ballMaterial);
		 light = new PointLight3D(true); 
		 light.z = -100; 
		 light.y = 100;
		cell = new CellMaterial(light, col2, col3,20);
		composite1.addMaterial(cell); 
		return(composite1)
	  }
}}
