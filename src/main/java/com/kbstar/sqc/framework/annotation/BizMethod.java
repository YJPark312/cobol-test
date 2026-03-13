package com.kbstar.sqc.framework.annotation;

import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface BizMethod {
    String value() default "";
}
