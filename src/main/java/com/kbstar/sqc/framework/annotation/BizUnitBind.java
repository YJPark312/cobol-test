package com.kbstar.sqc.framework.annotation;

import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface BizUnitBind {
    String value() default "";
}
