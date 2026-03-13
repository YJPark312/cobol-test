package com.kbstar.sqc.framework.annotation;

import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface BizUnit {
    String value() default "";
}
