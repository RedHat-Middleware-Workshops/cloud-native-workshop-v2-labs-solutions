// Class: io/quarkus/deployment/steps/ArcProcessor$generateResources14
//     Access =  public synthetic
//     Extends: java/lang/Object
//     Implements:
//         io/quarkus/runtime/StartupTask

// DO NOT MODIFY.  This is not actually a source file; it is a textual representation of generated code.
// Use only for debugging purposes.

// Auto-generated constructor
// Access: public
Method <init> : V
(
    // (no arguments)
) {
    ALOAD 0
    // Method descriptor: ()V
    INVOKESPECIAL java/lang/Object#<init>
    RETURN
    
}

// Access: public
Method deploy : V
(
    arg 1 = Lio/quarkus/runtime/StartupContext;
) {
    ** label1
    LDC (Integer) 5
    ANEWARRAY java/lang/Object
    ASTORE 2
    ALOAD 0
    ALOAD 1
    ALOAD 2
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;[Ljava/lang/Object;)V
    INVOKEVIRTUAL io/quarkus/deployment/steps/ArcProcessor$generateResources14#deploy_0
    RETURN
    ** label2
    
}

// Access: public
Method deploy_0 : V
(
    arg 1 = Lio/quarkus/runtime/StartupContext;,
    arg 2 = [Ljava/lang/Object;
) {
    ** label1
    NEW io/quarkus/arc/runtime/ArcRecorder
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/arc/runtime/ArcRecorder#<init>
    ASTORE 3
    ALOAD 2
    LDC (Integer) 0
    ALOAD 3
    AASTORE
    ALOAD 1
    LDC (String) "io.quarkus.runtime.ShutdownContext"
    // Method descriptor: (Ljava/lang/String;)Ljava/lang/Object;
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#getValue
    ASTORE 4
    ALOAD 2
    LDC (Integer) 0
    AALOAD
    ASTORE 16
    ALOAD 16
    CHECKCAST io/quarkus/arc/runtime/ArcRecorder
    ALOAD 4
    CHECKCAST io/quarkus/runtime/ShutdownContext
    // Method descriptor: (Lio/quarkus/runtime/ShutdownContext;)Lio/quarkus/arc/ArcContainer;
    INVOKEVIRTUAL io/quarkus/arc/runtime/ArcRecorder#getContainer
    ASTORE 5
    ALOAD 1
    LDC (String) "proxykey28"
    ALOAD 5
    // Method descriptor: (Ljava/lang/String;Ljava/lang/Object;)V
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#putValue
    NEW java/util/ArrayList
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL java/util/ArrayList#<init>
    ASTORE 6
    ALOAD 2
    LDC (Integer) 1
    ALOAD 6
    AASTORE
    ALOAD 2
    LDC (Integer) 1
    AALOAD
    ASTORE 8
    ALOAD 1
    LDC (String) "proxykey11"
    // Method descriptor: (Ljava/lang/String;)Ljava/lang/Object;
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#getValue
    ASTORE 7
    ALOAD 8
    CHECKCAST java/util/Collection
    ALOAD 7
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 1
    LDC (String) "proxykey20"
    // Method descriptor: (Ljava/lang/String;)Ljava/lang/Object;
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#getValue
    ASTORE 9
    ALOAD 8
    CHECKCAST java/util/Collection
    ALOAD 9
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 1
    LDC (String) "proxykey23"
    // Method descriptor: (Ljava/lang/String;)Ljava/lang/Object;
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#getValue
    ASTORE 10
    ALOAD 8
    CHECKCAST java/util/Collection
    ALOAD 10
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 1
    LDC (String) "proxykey24"
    // Method descriptor: (Ljava/lang/String;)Ljava/lang/Object;
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#getValue
    ASTORE 11
    ALOAD 8
    CHECKCAST java/util/Collection
    ALOAD 11
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 1
    LDC (String) "proxykey25"
    // Method descriptor: (Ljava/lang/String;)Ljava/lang/Object;
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#getValue
    ASTORE 12
    ALOAD 8
    CHECKCAST java/util/Collection
    ALOAD 12
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 2
    LDC (Integer) 2
    ALOAD 8
    AASTORE
    NEW java/util/HashSet
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL java/util/HashSet#<init>
    ASTORE 13
    ALOAD 2
    LDC (Integer) 3
    ALOAD 13
    AASTORE
    ALOAD 2
    LDC (Integer) 3
    AALOAD
    ASTORE 14
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.lang.Float"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.lang.Double"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "javax.resource.spi.XATerminator"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.lang.Integer"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.lang.Iterable"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "javax.servlet.http.HttpServletRequest"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "io.quarkus.arc.runtimebean.RuntimeBeanProducers"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.lang.Long"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.lang.Boolean"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "io.quarkus.undertow.runtime.ServletProducer"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "org.jboss.tm.XAResourceRecoveryRegistry"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.lang.String"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.lang.Number"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "javax.enterprise.context.control.RequestContextController"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "javax.servlet.ServletRequest"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.lang.CharSequence"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "io.quarkus.hibernate.orm.runtime.DefaultEntityManagerFactoryProducer"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.util.Collection"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "javax.transaction.UserTransaction"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "javax.servlet.http.HttpServletResponse"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "io.quarkus.arc.InjectableRequestContextController"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.util.Set"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "org.jboss.tm.JBossXATerminator"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "org.eclipse.microprofile.config.Config"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.io.Serializable"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.util.List"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "javax.servlet.ServletResponse"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "org.jboss.tm.usertx.UserTransactionRegistry"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "javax.persistence.EntityManagerFactory"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "io.quarkus.arc.runtime.QuarkusConfigProducer"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.util.Optional"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.lang.Comparable"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "java.lang.Object"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 14
    CHECKCAST java/util/Collection
    LDC (String) "javax.servlet.ServletContext"
    // Method descriptor: (Ljava/lang/Object;)Z
    INVOKEINTERFACE java/util/Collection#add
    POP
    ALOAD 2
    LDC (Integer) 4
    ALOAD 14
    AASTORE
    ALOAD 1
    LDC (String) "proxykey28"
    // Method descriptor: (Ljava/lang/String;)Ljava/lang/Object;
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#getValue
    ASTORE 17
    ALOAD 2
    LDC (Integer) 2
    AALOAD
    ASTORE 15
    ALOAD 2
    LDC (Integer) 4
    AALOAD
    ASTORE 18
    ALOAD 16
    CHECKCAST io/quarkus/arc/runtime/ArcRecorder
    ALOAD 17
    CHECKCAST io/quarkus/arc/ArcContainer
    ALOAD 15
    CHECKCAST java/util/List
    ALOAD 18
    CHECKCAST java/util/Collection
    // Method descriptor: (Lio/quarkus/arc/ArcContainer;Ljava/util/List;Ljava/util/Collection;)Lio/quarkus/arc/runtime/BeanContainer;
    INVOKEVIRTUAL io/quarkus/arc/runtime/ArcRecorder#initBeanContainer
    ASTORE 19
    ALOAD 1
    LDC (String) "proxykey30"
    ALOAD 19
    // Method descriptor: (Ljava/lang/String;Ljava/lang/Object;)V
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#putValue
    RETURN
    ** label2
    
}

