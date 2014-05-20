void main()
{
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_Position = ftransform(); //deprecated after GL 1.40
    
    /* equivalent in GL 3.1
     #version 140
     
     uniform Transformation {
     mat4 projection_matrix;
     mat4 modelview_matrix;
     };
     
     in vec3 vertex;
     
     void main(void) {
     gl_Position = projection_matrix * modelview_matrix * vec4(vertex, 1.0);
     }
    */
}
