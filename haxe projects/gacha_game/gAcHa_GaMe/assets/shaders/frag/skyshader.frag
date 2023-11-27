#ifdef GL_ES
precision mediump float;
#endif

// remove when transferring
uniform float u_time;

uniform vec2 u_resolution;
/*uniform*/ float iHour = u_time/2.*(.05);
float hour = mod(iHour, 2.);

// star stuff 101
float star_y() { return (sin(fract(hour)/.32)); }
float star_x() { return (fract(hour)); }
float glow(vec2 pxcd, vec2 coords, float radius){
    return ((smoothstep(0., distance(pxcd, coords), radius)));
}

// sun stuff
float sun(vec2 coords, vec2 sun_coords, float radius){
    return step(distance(coords, sun_coords), radius);
}

float sun_spinning(vec2 coords, vec2 center, float rad){
    vec2 sun_cd = vec2( (star_x()),               // horizontal
                        center.y+(star_y()/6.) ); // vertical

    return glow(coords, vec2(sun_cd), rad-.005) // draw the glow behind the sun
           + sun(coords, vec2(sun_cd), rad);    // draw the sun at sun_cd
}

// moon stuff
float moon(vec2 coords, vec2 sun_coords, float radius){
    float cut = step(distance(vec2(coords.x+.015, coords.y-.01), sun_coords), radius);
    // cut is a circle subtracted from the moon to make the C shape

    float moon = distance(coords, sun_coords);
    // make a circle (actually a gradient) at sun_coords
    moon = step(moon, radius);
    // make it a circle instead of a gradient
    moon = moon-cut;
    // subtract the [cut] part
    moon = max(moon, 0.);
    // avoid going negative (comment it to see what i mean)
    return moon;

}

float moon_spinning(vec2 coords, vec2 center, float rad){
    vec2 moon_cd = vec2( (star_x()),              // horizontal
                        center.y+(star_y()/6.) ); // vertical


    return glow(coords.xy+vec2(-.0125, .01), vec2(moon_cd), rad-.017)  // draw the glow behind the moon
           + moon(coords, vec2(moon_cd), rad);                         // draw the moon at moon_cd

}

// sky stuff
float sky(float yc){
    return smoothstep(0., 1., yc+.3);
}

vec3 gradualColor(vec3 startend, vec3 color){
    return mix(startend, color, star_y());
}

void main(){
    //hour+=1.;
    vec2 pos = gl_FragCoord.xy/u_resolution; // fix this so it doesn\' stretch
    vec3 draw = vec3(0.0, 0.0, 0.0);

    vec3 skytop, skybtm, star;
    if (hour > 1.0 && hour < 2.0){    // edit this to make different colors from day to night
        skytop = gradualColor(vec3(0.1569, 0.0, 0.498), vec3(0.0, 0.8, 1.0));
        skybtm = gradualColor(vec3(0.651, 0.302, 0.2863), vec3(0.949, 0.7804, 0.949));
        star = sun_spinning(pos, vec2(.5, .6), .025)                                      // add the sun mask
                * gradualColor(vec3(0.9647, 0.5961, 0.3333), vec3(0.9333, 0.9333, 0.8118)); // color it
    } else {
        skytop = gradualColor(vec3(0.1569, 0.0, 0.498), vec3(0.0, 0.0, 0.1451));
        skybtm = gradualColor(vec3(0.651, 0.302, 0.2863), vec3(0.2118, 0.0039, 0.2118));
        star = moon_spinning(pos, vec2(.5, .6), .025) // add the moon mask
                * gradualColor(vec3(0.0549, 0.0745, 0.4627), vec3(0.6824, 0.6706, 0.6706));     // color it
    }

    draw += mix(skybtm, skytop, sky(pos.y)); // add the sky
    draw += star;                            // add the star


    gl_FragColor = vec4(draw, 1.);
}
