import QtQuick 1.0
import Qt.labs.shaders 1.0

 Rectangle {
     width: 845
     height: 480
     color: "black"

     Text {
         id: textLabel
         text: "Hello World"
         anchors.centerIn: parent
         font.pixelSize: 64
         color: "white"

     }
     Rectangle{
color: "black"
         id:cos
         anchors.fill: parent

     }

     ShaderEffectItem {
         property variant source: ShaderEffectSource { sourceItem: cos; hideSource: true }
         property real wiggleAmount: 0.005
         property real time
         anchors.fill: textLabel

         NumberAnimation on time {
              from: 0
              to: Math.PI *1
              duration: 3600
              loops: Animation.Infinite
            }


         fragmentShader: "
         varying highp vec2 qt_TexCoord0;
         uniform sampler2D source;
         uniform highp float wiggleAmount;
         uniform highp float time;
     varying highp vec2 pos;
        #define M_PI 3.14159265358979323846
    #pragma debug(on)

//	varying highp float a = sin(1.1);
    const highp mat2 rotation = mat2(M_PI/4.0,M_PI/4.0,(M_PI/-4.0),M_PI/4.0);

//	highp mat2 rotation = mat2( cos(M_PI/4.0), sin(M_PI/4.0), -sin(M_PI/4.0), cos(M_PI/4.0));

         void main(void)
         {
                highp vec2 pos = mod((rotation*time) * gl_FragCoord.xy, vec2(50.0))-vec2(25.0);
        highp float dist_squared = dot (pos,pos);

//		highp vec2 wiggledTexCoord = qt_TexCoord0;

     gl_FragColor= mix(vec4(0.90, 0.90, 0.90,1.0),vec4(0.20,0.20,0.40,1.0),smoothstep(380.25,420.25,dist_squared));



        // wiggledTexCoord.s += sin(time * 3.141592653589 * wiggledTexCoord.t) * wiggleAmount;
                // gl_FragColor = texture2D(source, wiggledTexCoord.st);
         }
         "

}
 }
