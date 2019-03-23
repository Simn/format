package format.jvm;

import haxe.ds.Vector;
import haxe.Int64;
import haxe.io.Bytes;

// Constant pool

enum ConstantPoolEntry {
	CONSTANT_Class(name_index:Int);
	CONSTANT_Fieldref(class_index:Int, name_and_type_index:Int);
	CONSTANT_Methodref(class_index:Int, name_and_type_index:Int);
	CONSTANT_InterfaceMethodref(class_index:Int, name_and_type_index:Int);
	CONSTANT_String(string_index:Int);
	CONSTANT_Integer(i32:Int);
	CONSTANT_Float(f32:Float);
	CONSTANT_Long(i64:Int64);
	CONSTANT_Double(f64:Float);
	CONSTANT_NameAndType(name_index:Int, descriptor_index:Int);
	CONSTANT_Utf8(bytes:Bytes);
	CONSTANT_MethodHandle(reference_kind:Int, reference_index:Int);
	CONSTANT_MethodType(descriptor_index:Int);
	CONSTANT_InvokeDynamic(bootstrap_method_attr_index:Int, name_and_type_index:Int);
}

typedef ConstantPool = Array<ConstantPoolEntry>;

abstract ConstantPoolIndex(Int) from Int to Int {
	public function lookup(constantPool:ConstantPool) {
		return constantPool[this];
	}
}

// Instruction

enum abstract ArrayTypeCode(Int) from Int {
	var T_BOOLEAN = 4;
	var T_CHAR = 5;
	var T_FLOAT = 6;
	var T_DOUBLE = 7;
	var T_BYTE = 8;
	var T_SHORT = 9;
	var T_INT = 10;
	var T_LONG = 11;
}

enum Instruction {
	Aaload;
	Aastore;
	Aconst_null;
	Aload(index:Int);
	Aload_0;
	Aload_1;
	Aload_2;
	Aload_3;
	Anewarray(index:ConstantPoolIndex);
	AReturn;
	Arraylength;
	Astore(index:Int);
	Astore_0;
	Astore_1;
	Astore_2;
	Astore_3;
	Athrow;
	Baload;
	Bastore;
	Bipush(byte:Int);
	Caload;
	Castore;
	Checkcast(index:ConstantPoolIndex);
	D2f;
	D2i;
	D2l;
	Dadd;
	Daload;
	Dastore;
	Dcmpg;
	Dcmpl;
	Dconst_0;
	Dconst_1;
	Ddiv;
	Dload(index:Int);
	Dload_0;
	Dload_1;
	Dload_2;
	Dload_3;
	Dmul;
	Dneg;
	Drem;
	Dreturn;
	Dstore(index:Int);
	Dstore_0;
	Dstore_1;
	Dstore_2;
	Dstore_3;
	Dsub;
	Dup;
	Dup_x1;
	Dup_x2;
	Dup2;
	Dup2_x1;
	Dup2_x2;
	F2d;
	F2i;
	F2l;
	Fadd;
	Faload;
	Fastore;
	Fcmpg;
	Fcmpl;
	Fconst_0;
	Fconst_1;
	Fconst_2;
	FDiv;
	FLoad(index:Int);
	Fload_0;
	Fload_1;
	Fload_2;
	Fload_3;
	FMul;
	FNeg;
	Frem;
	FReturn;
	Fstore(index:Int);
	Fstore_0;
	Fstore_1;
	Fstore_2;
	Fstore_3;
	Fsub;
	Getfield(index:ConstantPoolIndex);
	Getstatic(index:ConstantPoolIndex);
	Goto(branch:Int);
	Goto_w(branch:Int);
	I2b;
	I2c;
	I2d;
	I2f;
	I2l;
	I2s;
	Iadd;
	Iaload;
	Iand;
	IAstore;
	Iconst_m1;
	Iconst_0;
	Iconst_1;
	Iconst_2;
	Iconst_3;
	Iconst_4;
	Iconst_5;
	Idiv;
	If_acmpeq(branch:Int);
	If_acmpne(branch:Int);
	If_icmpeq(branch:Int);
	If_icmpne(branch:Int);
	If_icmplt(branch:Int);
	If_icmpge(branch:Int);
	If_icmpgt(branch:Int);
	If_icmple(branch:Int);
	If_eq(branch:Int);
	If_ne(branch:Int);
	If_lt(branch:Int);
	If_ge(branch:Int);
	If_gt(branch:Int);
	If_le(branch:Int);
	Ifnonnull(branch:Int);
	Ifnull(branch:Int);
	Iinc(index:Int, const:Int);
	Iload(index:Int);
	Iload_0;
	Iload_1;
	Iload_2;
	Iload_3;
	Imul;
	Ineg;
	Instanceof(index:ConstantPoolIndex);
	Invokedynamic(index:ConstantPoolIndex);
	Invokeinterface(index:ConstantPoolIndex, count:Int);
	Invokespecial(index:ConstantPoolIndex);
	Invokestatic(index:ConstantPoolIndex);
	Invokevirtual(index:ConstantPoolIndex);
	Ior;
	Irem;
	Ireturn;
	Ishl;
	Ishr;
	Istore(index:Int);
	Istore_0;
	Istore_1;
	Istore_2;
	Istore_3;
	Isub;
	Iushr;
	Ixor;
	Jsr(branch:Int);
	Jsr_w(branch:Int);
	L2d;
	L2f;
	L2i;
	Ladd;
	Laload;
	Land;
	Lastore;
	Lcmp;
	Lconst_0;
	Lconst_1;
	Ldc(index:Int);
	Ldc_w(index:ConstantPoolIndex);
	Ldc2_w(index:ConstantPoolIndex);
	Ldiv;
	Lload(index:Int);
	Lload_0;
	Lload_1;
	Lload_2;
	Lload_3;
	Lmul;
	Lneg;
	Lookupswitch(defaultOffset:Int, pairs:Vector<{match:Int, offset:Int}>);
	Lor;
	Lrem;
	Lreturn;
	Lshl;
	Lshr;
	Lstore(index:Int);
	Lstore_0;
	Lstore_1;
	Lstore_2;
	Lstore_3;
	Lsub;
	Lushr;
	Lxor;
	Monitorenter;
	Monitorexit;
	Multianewarray(index:ConstantPoolIndex, dimensions:Int);
	New(index:ConstantPoolIndex);
	NewArray(atype:ArrayTypeCode);
	Nop;
	Pop;
	Pop2;
	Putfield(index:ConstantPoolIndex);
	Putstatic(index:ConstantPoolIndex);
	Ret(index:Int);
	Return;
	Saload;
	Sastore;
	Sipush(value:Int);
	Swap;
	Tableswitch(defaultOffset:Int, low:Int, high:Int, offsets:Vector<Int>);
	WideIinc(index:Int, const:Int);
	Wide(opcode:Int, index:ConstantPoolIndex);
}

// Annotation

enum Value {
	ConstValue(const_value_index:ConstantPoolIndex);
	EnumConstValue(type_name_index:ConstantPoolIndex, const_name_index:ConstantPoolIndex);
	ClassInfo(class_info_index:ConstantPoolIndex);
	AnnotationValue(annotation_value:Annotation);
	ArrayValue(array_value:Array<ElementValue>);
}

typedef ElementValue = {
	var tag:Int;
	var value:Value;
}

typedef Annotation = {
	var type_index:ConstantPoolIndex;
	var element_value_pairs:Array<{element_name_index:ConstantPoolIndex, element_value:ElementValue}>;
}

// Attribute

typedef LocalVariableTableEntryBase = {
	var start_pc:Int;
	var length:Int;
	var name_index:ConstantPoolIndex;
	var index:Int;
}

typedef LocalVariableTableEntry = LocalVariableTableEntryBase & {
	var descriptor_index:ConstantPoolIndex;
}

typedef LocalVariableTypeTableEntry = LocalVariableTableEntryBase & {
	var signature_index:ConstantPoolIndex;
}

typedef LineNumberTableEntry = {
	var start_pc:Int;
	var line_number:Int;
}

typedef ExceptionTableEntry = {
	var start_pc:Int;
	var end_pc:Int;
	var handler_pc:Int;
	var catch_type:ConstantPoolIndex;
}

typedef Code = {
	var max_stack:Int;
	var max_locals:Int;
	var code:Vector<Instruction>;
	var exception_table:Array<ExceptionTableEntry>;
	var attributes:Array<AttributeEntry>;
}

enum VerificationType {
	VTop;
	VInteger;
	VFloat;
	VDouble;
	VLong;
	VNull;
	VUninitializedThis;
	VObject(index:ConstantPoolIndex);
	VUninitialized(offset:Int);
}

enum StackMapFrameKind {
	SameFrame;
	SameLocals1StackItemFrame(stack:VerificationType);
	SameLocals1StackItemFrameExtended(offset_delta:Int, stack:VerificationType);
	ChopFrame(offset_delta:Int);
	SameFrameExtended(offset_delta:Int);
	AppendFrame(offset_delta:Int, locals:Array<VerificationType>);
	FullFrame(offset_delta:Int, locals:Array<VerificationType>, stack:Array<VerificationType>);
}

typedef StackMapFrame = {
	var frame_type:Int;
	var kind:StackMapFrameKind;
}

typedef InnerClassEntry = {
	var inner_class_info_index:ConstantPoolIndex;
	var outer_class_info_index:ConstantPoolIndex;
	var inner_name_index:ConstantPoolIndex;
	var inner_class_access_flags:ClassAccessFlags;
}

typedef BootstrapMethods = {
	var bootstrap_method_ref:Int;
	var bootstrap_arguments:Array<ConstantPoolIndex>;
}

enum Attribute {
	ConstantValue(constantvalue_index:ConstantPoolIndex);
	Code(code:Code);
	StackMapTable(entries:Array<StackMapFrame>);
	Exceptions(exceptions:Array<ConstantPoolIndex>);
	InnerClasses(classes:Array<InnerClassEntry>);
	EnclosingMethod(class_index:ConstantPoolIndex, method_index:ConstantPoolIndex);
	Synthetic;
	Signature(signature_index:ConstantPoolIndex);
	SourceFile(sourcefile_index:ConstantPoolIndex);
	SourceDebugExtension(debug_extension:Bytes);
	LineNumberTable(table:Array<LineNumberTableEntry>);
	LocalVariableTable(locals:Array<LocalVariableTableEntry>);
	LocalVariableTypeTable(locals:Array<LocalVariableTypeTableEntry>);
	Deprecated;
	RuntimeVisibleAnnotations(annotations:Array<Annotation>);
	RuntimeInvisibleAnnotations(annotations:Array<Annotation>);
	RuntimeVisibleParameterAnnotations(parameter_annotations:Array<Array<Annotation>>);
	RuntimeInvisibleParameterAnnotations(parameter_annotations:Array<Array<Annotation>>);
	AnnotationDefault(default_value:ElementValue);
	BootstrapMethods(bootstrap_methods:Array<BootstrapMethods>);
}

typedef AttributeEntry = {
	var attribute_name_index:ConstantPoolIndex;
	var attribute_length:Int;
	var attribute_info:Attribute;
}

// Flag

enum abstract ClassAccessFlags(Int) {
	var ACC_PUBLIC = 0x0001;
	var ACC_FINAL = 0x0010;
	var ACC_SUPER = 0x0020;
	var ACC_INTERFACE = 0x0200;
	var ACC_ABSTRACT = 0x0400;
	var ACC_SYNTHETIC = 0x1000;
	var ACC_ANNOTATION = 0x2000;
	var ACC_ENUM = 0x4000;

	public function new(value:Int) {
		this = value;
	}
}

enum abstract FieldAccessFlags(Int) {
	var ACC_PUBLIC = 0x0001;
	var ACC_PRIVATE = 0x0002;
	var ACC_PROTECTED = 0x0004;
	var ACC_STATIC = 0x0008;
	var ACC_FINAL = 0x0010;
	var ACC_VOLATILE = 0x0040;
	var ACC_TRANSIENT = 0x0080;
	var ACC_SYNTHETIC = 0x1000;
	var ACC_ENUM = 0x4000;

	public function new(value:Int) {
		this = value;
	}
}

enum abstract MethodAccessFlags(Int) {
	var ACC_PUBLIC = 0x0001;
	var ACC_PRIVATE = 0x0002;
	var ACC_PROTECTED = 0x0004;
	var ACC_STATIC = 0x0008;
	var ACC_FINAL = 0x0010;
	var ACC_SYNCHRONIZED = 0x0020;
	var ACC_BRIDGE = 0x0040;
	var ACC_VARARGS = 0x0080;
	var ACC_NATIVE = 0x0100;
	var ACC_ABSTRACT = 0x0400;
	var ACC_STRICT = 0x0800;
	var ACC_SYNTHETIC = 0x1000;

	public function new(value:Int) {
		this = value;
	}
}

// Class

typedef Field = {
	var access_flags:FieldAccessFlags;
	var name_index:ConstantPoolIndex;
	var descriptor_index:ConstantPoolIndex;
	var attributes:Array<AttributeEntry>;
}

typedef Method = {
	var access_flags:MethodAccessFlags;
	var name_index:ConstantPoolIndex;
	var descriptor_index:ConstantPoolIndex;
	var attributes:Array<AttributeEntry>;
}

typedef JClass = {
	var minor_version:Int;
	var major_version:Int;
	var constant_pool:ConstantPool;
	var access_flags:ClassAccessFlags;
	var this_class:ConstantPoolIndex;
	var super_class:ConstantPoolIndex;
	var interfaces:Array<ConstantPoolIndex>;
	var fields:Array<Field>;
	var methods:Array<Method>;
	var attributes:Array<AttributeEntry>;
}
