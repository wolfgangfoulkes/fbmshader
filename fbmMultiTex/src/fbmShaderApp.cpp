#include "cinder/app/AppNative.h"
#include "cinder/gl/gl.h"
#include "cinder/ImageIo.h"
#include "cinder/gl/Texture.h"
#include "cinder/gl/GlslProg.h"

#include "Resources.h"

using namespace ci;
using namespace ci::app;
using namespace std;

class fbmShaderApp : public AppNative {
  public:
	void setup();
	void update();
	void draw();
    
    string sTopTex = "pixelkid.jpg";
    string sDissTex = "Blackened-Chicken-Pre-Cooked.jpg";
    
    gl::TextureRef topTexture;
    gl::Texture dissolveMap;
    gl::GlslProgRef fbmShader;
    gl::GlslProg mtShader;
    float mAngle;
    float millis;
    int frames;
};

void fbmShaderApp::setup()
{
    try
    {
		topTexture = gl::Texture::create( loadImage( loadResource(sTopTex) ) );
	}
	catch( ... )
    {
		std::cout << "unable to load the texture file!" << sTopTex << std::endl;
	}
    
    try
    {
		dissolveMap = *gl::Texture::create( loadImage( loadResource(sDissTex) ) );
	}
	catch( ... )
    {
		std::cout << "unable to load" << sDissTex << std::endl;
	}
	
	try
    {
		fbmShader = gl::GlslProg::create( loadResource( "passthru110_vert.glsl" ), loadResource( "fbmTex_frag.glsl" ) );
	}
	catch( gl::GlslProgCompileExc &exc )
    {
		std::cout << "Shader compile error: " << std::endl;
		std::cout << exc.what();
	}
	catch( ... )
    {
		std::cout << "Unable to load shader" << std::endl;
	}
    
    try
    {
		mtShader = *gl::GlslProg::create( loadResource( "passthru110_vert.glsl" ), loadResource( "multiTex2_frag.glsl" ) );
	}
	catch( gl::GlslProgCompileExc &exc )
    {
		std::cout << "Shader compile error: " << std::endl;
		std::cout << exc.what();
	}
	catch( ... )
    {
		std::cout << "Unable to load shader" << std::endl;
	}


}

void fbmShaderApp::update()
{
    millis = getElapsedSeconds() * .001;
    cout << "millis:" << millis << "\n";
    //frames = getElapsedFrames();
}

void fbmShaderApp::draw()
{
	// clear out the window with black
	gl::clear( Color( 0, 0, 0 ) );
    
    //bind textures to units 0 and 1. there are 32.
    topTexture->bind(0);
    dissolveMap.bind(1);
    
    fbmShader->bind();
    fbmShader->uniform("fTime", millis);
    fbmShader->uniform("resolution", Vec2f(getWindowWidth(), getWindowHeight()));
    fbmShader->unbind(); //think this is nec for loading another shader.
    
    mtShader.bind();
    //pass textures from units 0 and 1
    mtShader.uniform("tex0", 0);
    mtShader.uniform("tex1", 1);
    
    mtShader.uniform("resolution", Vec2f(getWindowWidth(), getWindowHeight()));
    mtShader.uniform("scale", Vec2f(1.0, 1.0));
    
    mtShader.uniform("fTime", millis);
    mtShader.uniform("fFloor", (float) fmod(millis * 100, 1.0)); //if you pass in a number without casting, we get an "ambiguous" error from c++
    mtShader.uniform("fMix", (float) fmod(millis * 100, 1.0)); //set range to 0 - 1.76ish in shader
    
    gl::drawSolidRect( getWindowBounds() );
    
    topTexture->unbind();
    dissolveMap.unbind();
}

CINDER_APP_NATIVE( fbmShaderApp, RendererGl )
