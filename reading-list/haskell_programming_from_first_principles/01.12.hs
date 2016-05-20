Combinators
1. λx.xxx
nThis one is a combinator. None of the variables in the body are free.
2. λxy.zx
This one is not a combinator. The z in the body is free.
3. λxyz.xy(zx)
This one is a combinator. All of the values in the body are bound
4. λxyz.xy(zxy)
Same as 3.
5. λyx.yx(zxy)
This one is not a combinator. The z in the body is not bound.

Normal Form or Diverge?
1. λx.xxx
This is already in normal form.
2. (λz.zz)(λy.yy)
This is divergent. When you apply, you end up with the same non-normal form function.
3. (λx.xxx)z
   zzz
This can be reduced to normal form.

-- Beta Reduce
1. (λabc.cba)zz(λwv.w)
   (λbc.cbz)z(λwv.w)
   (λc.czz)(λwv.w)
   (λwv.w)zz
   (λv.z)z
   z
2. (λx.λy.xyy)(λa.a)b
   (λy.(λa.a)yy)(b)
   (λa.a)(b)b
   bb
3. (λy.y)(λx.xx)(λz.zq)
   (λx.xx)(λz.zq)
   (λz.zq)(λz.zq)
   (λz.zq)q
   qq
4. (λz.z)(λz.zz)(λz.zy)
   (λz.zz)(λz.zy)
   (λz.zy)(λz.zy)
   yy
5. (λx.λy.xyy)(λy.y)y
   (λy.(λy.y)yy)(y)
   (λy.y)yy
   yy
6. (λa.aa)(λb.ba)c
   (λb.ba)(λb.ba)c
   (λb.ba)a(c)
   aac
7. (λxyz.xz(yz))(λx.z)(λx.a)
   (λx.λy.λz.xz(yz))(λx.z)(λx.a)
   (λy.λz'.(λx.z)z'(yz'))(λx.a)
   (λz'.(λx.z)(z')(λx.a)(z'))
   (λz'.z(λx.a)(z'))
   (λz'.za)
