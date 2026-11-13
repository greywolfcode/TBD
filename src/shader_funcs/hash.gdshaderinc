/** 
Hash function by David Hoskins, which is under MIT License
Source Site: https://www.shadertoy.com/view/4djSRW
License:
  Copyright (c)2014 David Hoskins.
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
*/
vec3 hash_3D(vec3 p)
{
	p = vec3(dot(p,vec3(127.1,311.7, 74.7)),
			 dot(p,vec3(269.5,183.3,246.1)),
			 dot(p,vec3(113.5,271.9,124.6)));

	return fract((p.xxy + p.yxx) * p.zyx);
}

vec2 hash_2D(vec2 p)
{
	p = vec2(dot(p,vec2(127.1,311.7)),
			 dot(p,vec2(269.5,183.3)));

	return fract((p.xx + p.yx) * p.yy);
}
