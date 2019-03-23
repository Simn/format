package format.jvm;

import format.jvm.Data;
import haxe.Int64;
import haxe.io.Encoding;
import haxe.io.Input;

class Reader {
	var i:Input;
	var constantPool:ConstantPool;

	public function new(i:Input) {
		this.i = i;
		i.bigEndian = true;
	}

	function readUInt16Array<T>(f:Void->T) {
		return [for (_ in 0...i.readUInt16()) f()];
	}

	// Constant pool

	function readConstantPoolEntry() {
		return switch (i.readByte()) {
			case 1: CONSTANT_Utf8(i.read(i.readUInt16()));
			case 3: CONSTANT_Integer(i.readInt32());
			case 4: CONSTANT_Float(i.readFloat());
			case 5: CONSTANT_Long(Int64.make(i.readInt32(), i.readInt32()));
			case 6: CONSTANT_Double(i.readDouble());
			case 7: CONSTANT_Class(i.readUInt16());
			case 8: CONSTANT_String(i.readUInt16());
			case 9: CONSTANT_Fieldref(i.readUInt16(), i.readUInt16());
			case 10: CONSTANT_Methodref(i.readUInt16(), i.readUInt16());
			case 11: CONSTANT_InterfaceMethodref(i.readUInt16(), i.readUInt16());
			case 12: CONSTANT_NameAndType(i.readUInt16(), i.readUInt16());
			case 15: CONSTANT_MethodHandle(i.readByte(), i.readUInt16());
			case 16: CONSTANT_MethodType(i.readUInt16());
			case 18: CONSTANT_InvokeDynamic(i.readUInt16(), i.readUInt16());
			case i: throw 'Invalid constant pool kind: $i';
		}
	}

	function readConstantPool() {
		var count = i.readUInt16();
		var constantPool = [];
		var entryNumber = 1;
		while (entryNumber < count) {
			var entry = readConstantPoolEntry();
			constantPool[entryNumber] = entry;
			switch (entry) {
				case CONSTANT_Long(_) | CONSTANT_Double(_):
					entryNumber += 2;
				case _:
					++entryNumber;
			}
		}
		return constantPool;
	}

	function readConstantPoolIndex() {
		return i.readUInt16();
	}

	// Annotation

	function readElementValue() {
		var tag = i.readByte();
		var value = switch (tag) {
			case 'B'.code | 'C'.code | 'D'.code | 'F'.code | 'I'.code | 'J'.code | 'S'.code | 'Z'.code | 's'.code:
				ConstValue(readConstantPoolIndex());
			case 'e'.code:
				EnumConstValue(readConstantPoolIndex(), readConstantPoolIndex());
			case 'c'.code:
				ClassInfo(readConstantPoolIndex());
			case '@'.code:
				AnnotationValue(readAnnotation());
			case '['.code:
				ArrayValue(readUInt16Array(readElementValue));
			case c:
				throw 'Unrecognized element_value tag: ${String.fromCharCode(c)}';
		}
		return {
			tag: tag,
			value: value
		}
	}

	function readElementValuePairs() {
		return readUInt16Array(() -> {
			element_name_index: readConstantPoolIndex(),
			element_value: readElementValue()
		});
	}

	function readParameterAnnotations() {
		return [
			for (_ in 0...i.readByte())
				readUInt16Array(readAnnotation)];
	}

	function readAnnotation() {
		return {
			type_index: i.readUInt16(),
			element_value_pairs: readElementValuePairs()
		}
	}

	function readAnnotations() {
		return readUInt16Array(readAnnotation);
	}

	// Attribute

	function readCode():Code {
		function readCode() {
			var count = i.readInt32();
			var r = new InstructionReader(i);
			return r.read(count);
		}
		function readExceptionTable() {
			return readUInt16Array(() -> {
				start_pc: i.readUInt16(),
				end_pc: i.readUInt16(),
				handler_pc: i.readUInt16(),
				catch_type: readConstantPoolIndex()
			});
		}
		return {
			max_stack: i.readUInt16(),
			max_locals: i.readUInt16(),
			code: readCode(),
			exception_table: readExceptionTable(),
			attributes: readAttributes()
		}
	}

	function readVerificationType() {
		return switch (i.readByte()) {
			case 0: VTop;
			case 1: VInteger;
			case 2: VFloat;
			case 3: VDouble;
			case 4: VLong;
			case 5: VNull;
			case 6: VUninitializedThis;
			case 7: VObject(readConstantPoolIndex());
			case 8: VUninitialized(i.readUInt16());
			case i: throw 'Unrecognized verification type: $i';
		}
	}

	function readStackMapFrame() {
		var frame_type = i.readByte();
		var kind = if (frame_type < 64) {
			SameFrame;
		} else if (frame_type < 128) {
			SameLocals1StackItemFrame(readVerificationType());
		} else if (frame_type < 247) {
			throw 'Invalid frame_type: $frame_type';
		} else if (frame_type == 247) {
			SameLocals1StackItemFrameExtended(i.readUInt16(), readVerificationType());
		} else if (frame_type < 251) {
			ChopFrame(i.readUInt16());
		} else if (frame_type == 251) {
			SameFrameExtended(i.readUInt16());
		} else if (frame_type < 255) {
			AppendFrame(i.readUInt16(), [for (_ in 0...frame_type - 251) readVerificationType()]);
		} else {
			FullFrame(i.readUInt16(), readUInt16Array(readVerificationType), readUInt16Array(readVerificationType));
		}
		return {
			frame_type: frame_type,
			kind: kind
		}
	}

	function readExceptions() {
		return readUInt16Array(readConstantPoolIndex);
	}

	function readInnerClasses() {
		return readUInt16Array(() -> {
			inner_class_info_index: readConstantPoolIndex(),
			outer_class_info_index: readConstantPoolIndex(),
			inner_name_index: readConstantPoolIndex(),
			inner_class_access_flags: new ClassAccessFlags(i.readInt16())
		});
	}

	function readLineNumberTable() {
		return readUInt16Array(() -> {
			start_pc: i.readUInt16(),
			line_number: i.readUInt16()
		});
	}

	function readLocalVariableTable() {
		return readUInt16Array(() -> {
			start_pc: i.readUInt16(),
			length: i.readUInt16(),
			name_index: readConstantPoolIndex(),
			descriptor_index: readConstantPoolIndex(),
			index: i.readUInt16()
		});
	}

	function readLocalVariableTypeTable() {
		return readUInt16Array(() -> {
			start_pc: i.readUInt16(),
			length: i.readUInt16(),
			name_index: readConstantPoolIndex(),
			signature_index: readConstantPoolIndex(),
			index: i.readUInt16()
		});
	}

	function readBootstrapMethods() {
		return readUInt16Array(() -> {
			bootstrap_method_ref: readConstantPoolIndex(),
			bootstrap_arguments: readUInt16Array(readConstantPoolIndex)
		});
	}

	function readAttribute():AttributeEntry {
		var attributeName = readConstantPoolIndex();
		var ref = switch (constantPool[attributeName]) {
			case CONSTANT_Utf8(bytes): bytes.getString(0, bytes.length, Encoding.UTF8);
			case c: throw 'CONSTANT_Utf8 expected, found $c';
		}
		var length = i.readInt32();
		var attribute = switch (ref) {
			case "ConstantValue": ConstantValue(readConstantPoolIndex());
			case "Code": Code(readCode());
			case "StackMapTable": StackMapTable(readUInt16Array(readStackMapFrame));
			case "Exceptions": Exceptions(readExceptions());
			case "InnerClasses": InnerClasses(readInnerClasses());
			case "EnclosingMethod": EnclosingMethod(readConstantPoolIndex(), readConstantPoolIndex());
			case "Synthetic": Synthetic;
			case "Signature": Signature(readConstantPoolIndex());
			case "SourceFile": SourceFile(readConstantPoolIndex());
			case "SourceDebugExtension": SourceDebugExtension(i.read(length));
			case "LineNumberTable": LineNumberTable(readLineNumberTable());
			case "LocalVariableTable": LocalVariableTable(readLocalVariableTable());
			case "LocalVariableTypeTable": LocalVariableTypeTable(readLocalVariableTypeTable());
			case "Deprecated": Deprecated;
			case "RuntimeVisibleAnnotations": RuntimeVisibleAnnotations(readAnnotations());
			case "RuntimeInvisibleAnnotations": RuntimeInvisibleAnnotations(readAnnotations());
			case "RuntimeVisibleParameterAnnotations": RuntimeVisibleParameterAnnotations(readParameterAnnotations());
			case "RuntimeInvisibleParameterAnnotations": RuntimeInvisibleParameterAnnotations(readParameterAnnotations());
			case "AnnotationDefault": AnnotationDefault(readElementValue());
			case "BootstrapMethods": BootstrapMethods(readBootstrapMethods());
			case s: throw 'Unrecognized attribute name: $s';
		}
		return {
			attribute_name_index: attributeName,
			attribute_length: length,
			attribute_info: attribute
		}
	}

	function readAttributes() {
		return readUInt16Array(readAttribute);
	}

	// Field

	function readField() {
		return {
			access_flags: new FieldAccessFlags(i.readUInt16()),
			name_index: readConstantPoolIndex(),
			descriptor_index: readConstantPoolIndex(),
			attributes: readAttributes()
		}
	}

	function readMethod() {
		return {
			access_flags: new MethodAccessFlags(i.readUInt16()),
			name_index: readConstantPoolIndex(),
			descriptor_index: readConstantPoolIndex(),
			attributes: readAttributes()
		}
	}

	// Class

	function readInterfaces() {
		return readUInt16Array(readConstantPoolIndex);
	}

	function readFields() {
		return readUInt16Array(readField);
	}

	function readMethods() {
		return readUInt16Array(readMethod);
	}

	public function read():JClass {
		if (i.readInt32() != 0xCAFEBABE) {
			throw "Invalid header";
		}
		return {
			minor_version: i.readUInt16(),
			major_version: i.readUInt16(),
			constant_pool: constantPool = readConstantPool(),
			access_flags: new ClassAccessFlags(i.readUInt16()),
			this_class: readConstantPoolIndex(),
			super_class: readConstantPoolIndex(),
			interfaces: readInterfaces(),
			fields: readFields(),
			methods: readMethods(),
			attributes: readAttributes()
		};
	}
}
