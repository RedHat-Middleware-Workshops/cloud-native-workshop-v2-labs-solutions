// Class: io/quarkus/runner/ApplicationImpl1
//     Access =  public synthetic
//     Extends: io/quarkus/runtime/Application

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
    INVOKESPECIAL io/quarkus/runtime/Application#<init>
    RETURN
    
}

// Access: static
Field STARTUP_CONTEXT : Lio/quarkus/runtime/StartupContext;

// Access: protected final
Method doStart : V
(
    arg 1 = [Ljava/lang/String;
) {
    ** label1
    LDC (String) "java.util.logging.manager"
    LDC (String) "org.jboss.logmanager.LogManager"
    // Method descriptor: (Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    INVOKESTATIC java/lang/System#setProperty
    POP
    LDC (String) "java.library.path"
    LDC (String) "/Users/doh/cloud-native-app-dev/quarkus/graalvm-ce-19.1.1/Contents/Home/jre/lib"
    // Method descriptor: (Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    INVOKESTATIC java/lang/System#setProperty
    POP
    LDC (String) "java.library.path"
    // Method descriptor: (Ljava/lang/String;)Ljava/lang/String;
    INVOKESTATIC java/lang/System#getProperty
    ASTORE 2
    NEW java/lang/StringBuilder
    DUP
    ALOAD 2
    // Method descriptor: (Ljava/lang/String;)V
    INVOKESPECIAL java/lang/StringBuilder#<init>
    ASTORE 3
    ALOAD 3
    // Method descriptor: ()I
    INVOKEVIRTUAL java/lang/StringBuilder#length
    IFNE label2
    ** label3
    ** label4
    GOTO label5
    ** label2
    ALOAD 3
    LDC (String) ":"
    // Method descriptor: (Ljava/lang/String;)Ljava/lang/StringBuilder;
    INVOKEVIRTUAL java/lang/StringBuilder#append
    POP
    ** label5
    ALOAD 3
    LDC (String) "."
    // Method descriptor: (Ljava/lang/String;)Ljava/lang/StringBuilder;
    INVOKEVIRTUAL java/lang/StringBuilder#append
    POP
    ALOAD 3
    // Method descriptor: ()Ljava/lang/String;
    INVOKEVIRTUAL java/lang/StringBuilder#toString
    ASTORE 4
    LDC (String) "java.library.path"
    ALOAD 4
    // Method descriptor: (Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    INVOKESTATIC java/lang/System#setProperty
    POP
    LDC (String) "javax.net.ssl.trustStore"
    // Method descriptor: (Ljava/lang/String;)Ljava/lang/String;
    INVOKESTATIC java/lang/System#getProperty
    ASTORE 5
    // Method descriptor: ()Z
    INVOKESTATIC org/graalvm/nativeimage/ImageInfo#inImageRuntimeCode
    IFNE label6
    ** label7
    ** label8
    GOTO label9
    ** label6
    ALOAD 5
    IFNULL label10
    ** label11
    ** label12
    GOTO label13
    ** label10
    LDC (String) "javax.net.ssl.trustStore"
    LDC (String) "/Users/doh/cloud-native-app-dev/quarkus/graalvm-ce-19.1.1/Contents/Home/jre/lib/security/cacerts"
    // Method descriptor: (Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    INVOKESTATIC java/lang/System#setProperty
    POP
    ** label13
    ** label9
    // Method descriptor: ()V
    INVOKESTATIC io/quarkus/runtime/Timing#mainStarted
    // Field descriptor: Lio/quarkus/runtime/StartupContext;
    GETSTATIC io/quarkus/runner/ApplicationImpl1#STARTUP_CONTEXT
    ASTORE 6
    ** label14
    // Method descriptor: ()V
    INVOKESTATIC io/quarkus/runtime/generated/RunTimeConfig#getRunTimeConfiguration
    NEW io/quarkus/deployment/steps/AgroalProcessor$configureRuntimeProperties3
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/AgroalProcessor$configureRuntimeProperties3#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 6
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/LoggingResourceProcessor$setupLoggingRuntimeInit6
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/LoggingResourceProcessor$setupLoggingRuntimeInit6#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 6
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/ThreadPoolSetup$createExecutor4
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/ThreadPoolSetup$createExecutor4#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 6
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/NarayanaJtaProcessor$build5
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/NarayanaJtaProcessor$build5#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 6
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/ConfigBuildStep$validateConfigProperties15
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/ConfigBuildStep$validateConfigProperties15#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 6
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/HibernateOrmProcessor$startPersistenceUnits17
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/HibernateOrmProcessor$startPersistenceUnits17#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 6
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/UndertowBuildStep$boot20
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/UndertowBuildStep$boot20#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 6
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/LifecycleEventsBuildStep$startupEvent21
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/LifecycleEventsBuildStep$startupEvent21#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 6
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    LDC (String) "0.21.1"
    LDC (String) "agroal, cdi, hibernate-orm, jdbc-h2, jdbc-postgresql, narayana-jta, resteasy, resteasy-jsonb"
    // Method descriptor: (Ljava/lang/String;Ljava/lang/String;)V
    INVOKESTATIC io/quarkus/runtime/Timing#printStartupTime
    ** label15
    GOTO label16
    ** label17
    ASTORE 7
    ALOAD 7
    // Method descriptor: ()V
    INVOKEVIRTUAL java/lang/Throwable#printStackTrace
    ALOAD 6
    // Method descriptor: ()V
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#close
    NEW java/lang/RuntimeException
    DUP
    LDC (String) "Failed to start quarkus"
    ALOAD 7
    // Method descriptor: (Ljava/lang/String;Ljava/lang/Throwable;)V
    INVOKESPECIAL java/lang/RuntimeException#<init>
    CHECKCAST java/lang/Throwable
    ATHROW
    ** label18
    GOTO label16
    // Try from label14 to label15
    // Catch java/lang/Throwable by going to label17
    ** label16
    RETURN
    ** label19
    
}

// Access: protected final
Method doStop : V
(
    // (no arguments)
) {
    ** label1
    // Field descriptor: Lio/quarkus/runtime/StartupContext;
    GETSTATIC io/quarkus/runner/ApplicationImpl1#STARTUP_CONTEXT
    // Method descriptor: ()V
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#close
    RETURN
    ** label2
    
}

// Access: public static
Method <clinit> : V
(
    // (no arguments)
) {
    ** label1
    LDC (String) "java.util.logging.manager"
    LDC (String) "org.jboss.logmanager.LogManager"
    // Method descriptor: (Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    INVOKESTATIC java/lang/System#setProperty
    POP
    LDC (String) "java.library.path"
    LDC (String) "/Users/doh/cloud-native-app-dev/quarkus/graalvm-ce-19.1.1/Contents/Home/jre/lib"
    // Method descriptor: (Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    INVOKESTATIC java/lang/System#setProperty
    POP
    // Method descriptor: ()V
    INVOKESTATIC io/quarkus/runtime/Timing#staticInitStarted
    NEW io/quarkus/runtime/StartupContext
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/runtime/StartupContext#<init>
    ASTORE 0
    ALOAD 0
    // Field descriptor: Lio/quarkus/runtime/StartupContext;
    PUTSTATIC io/quarkus/runner/ApplicationImpl1#STARTUP_CONTEXT
    ** label2
    NEW io/quarkus/deployment/steps/LoggingResourceProcessor$setupLoggingStaticInit1
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/LoggingResourceProcessor$setupLoggingStaticInit1#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 0
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/AgroalProcessor$build2
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/AgroalProcessor$build2#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 0
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/SubstrateConfigBuildStep$build9
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/SubstrateConfigBuildStep$build9#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 0
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/UndertowBuildStep$servletContextBean8
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/UndertowBuildStep$servletContextBean8#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 0
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/RuntimeBeanProcessor$build12
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/RuntimeBeanProcessor$build12#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 0
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/HibernateOrmProcessor$build7
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/HibernateOrmProcessor$build7#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 0
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/HibernateOrmProcessor$build13
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/HibernateOrmProcessor$build13#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 0
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/ArcProcessor$generateResources14
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/ArcProcessor$generateResources14#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 0
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/ResteasyServerCommonProcessor$setupInjection16
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/ResteasyServerCommonProcessor$setupInjection16#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 0
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/UndertowArcIntegrationBuildStep$integrateRequestContext18
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/UndertowArcIntegrationBuildStep$integrateRequestContext18#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 0
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    NEW io/quarkus/deployment/steps/UndertowBuildStep$build19
    DUP
    // Method descriptor: ()V
    INVOKESPECIAL io/quarkus/deployment/steps/UndertowBuildStep$build19#<init>
    CHECKCAST io/quarkus/runtime/StartupTask
    ALOAD 0
    // Method descriptor: (Lio/quarkus/runtime/StartupContext;)V
    INVOKEINTERFACE io/quarkus/runtime/StartupTask#deploy
    RETURN
    ** label3
    GOTO label4
    ** label5
    ASTORE 1
    ALOAD 0
    // Method descriptor: ()V
    INVOKEVIRTUAL io/quarkus/runtime/StartupContext#close
    NEW java/lang/RuntimeException
    DUP
    LDC (String) "Failed to start quarkus"
    ALOAD 1
    // Method descriptor: (Ljava/lang/String;Ljava/lang/Throwable;)V
    INVOKESPECIAL java/lang/RuntimeException#<init>
    CHECKCAST java/lang/Throwable
    ATHROW
    ** label6
    GOTO label4
    // Try from label2 to label3
    // Catch java/lang/Throwable by going to label5
    ** label4
    ** label7
    
}

