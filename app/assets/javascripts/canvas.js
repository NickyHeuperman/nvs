$(document).ready(function() {

	var canvas = document.getElementById('fittingCanvas');
	if(canvas.getContext){
		var ctx = canvas.getContext('2d');
		var radius =256;
		var innerRadius = radius-43;
		/*ctx.beginPath();
		ctx.arc(radius,radius,radius,0,Math.PI*2,false);
		ctx.stroke();
		ctx.closePath();
		ctx.beginPath();
		ctx.arc(radius,radius,innerRadius,0,Math.PI*2,false);
		ctx.stroke();
		ctx.closePath();*/
		var spacing =1;
		var offset=0;
		for(var i=0;i<32;i++){
		//radius * cos(degrees)= x radius * sin(degrees)=y
		// 0= 0 en 9, 1 = 11 en 20, 2= 22 en 31
			
			
			var min=(0*9)+(0*spacing);
			var max=((31*9)+9)+(32*spacing);
			//alert(max);
			var degreeStart=(i*9)+(i*spacing);
			degreeStart+=offset;
			var degreeEnd=((i*9)+9)+(i*spacing);
			degreeEnd+=offset;
			degreeStart-=60;
			degreeEnd-=60;
			ctx.strokeStyle="white";
			degreeStart=degreesToRads(degreeStart);
			degreeEnd=degreesToRads(degreeEnd);
			var x1= radius*Math.cos(degreeStart);
			var x2= innerRadius*Math.cos(degreeStart);
			var y1= radius*Math.sin(degreeStart);
			var y2= innerRadius*Math.sin(degreeStart);
			var x3= radius*Math.cos(degreeEnd);
			var x4= innerRadius*Math.cos(degreeEnd);
			var y3= radius*Math.sin(degreeEnd);
			var y4= innerRadius*Math.sin(degreeEnd);
			x1+=256;
			y1+=256;
			x2+=256;
			y2+=256;
			x3+=256;
			y3+=256;
			x4+=256;
			y4+=256;
			//alert('x1='+x1+' x2='+x2+' y1='+y1+' y2='+y2+' x3='+x3+' y3='+y3+' x4='+x4+' y4='+y4+' i='+i);
			//alert('begin='+degreeStart+" end="+degreeEnd+ "i="+i);
			ctx.beginPath();
			ctx.moveTo(x1,y1);
			ctx.lineTo(x2,y2);
			ctx.stroke();
			ctx.closePath();
			ctx.beginPath();
			ctx.moveTo(x3,y3);
			ctx.lineTo(x4,y4);
			ctx.stroke();
			ctx.closePath();
			ctx.beginPath();
			ctx.arc(radius,radius,innerRadius,degreeStart,degreeEnd,false);
			ctx.strokeStyle="white";
			ctx.stroke();
			ctx.closePath();
			ctx.beginPath();
			ctx.arc(radius,radius,radius,degreeStart,degreeEnd,false);
			ctx.strokeStyle="white";
			ctx.stroke();
			ctx.closePath();
			if(i==0||i==8||i==16||i==24||i==21){
			offset+=8;
			//alert(spacing);
			}
			if(i==31){
			//alert(((i*9)+9)+(i*spacing)+offset);
			}
		}
		
	}
	var strDataURI = canvas.toDataURL();
	document.getElementById('canvasImg').src = strDataURI;

});
function degreesToRads(degrees){
return (degrees/360)*(Math.PI*2);
}