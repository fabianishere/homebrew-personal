class GnuEfi < Formula
  desc "Library for building UEFI Applications using GNU toolchain"
  homepage "https://sourceforge.net/projects/gnu-efi/"
  url "https://downloads.sourceforge.net/project/gnu-efi/gnu-efi-3.0.9.tar.bz2"
  sha256 "6715ea7eae1c7e4fc5041034bd3f107ec2911962ed284a081e491646b12277f0"

  depends_on "libelf" => :build
  depends_on "mingw-w64" => :build

  patch :DATA

  def install
    ENV["PREFIX"] = prefix
    ENV["CROSS_COMPILE"] = "x86_64-w64-mingw32-"
    ENV["PATH"] = "#{ENV["PATH"]}:#{Formula["mingw-w64"].bin}"
    ENV["C_INCLUDE_PATH"] = Formula["libelf"].include

    system "make"
    system "make", "install"
  end

  test do
    (testpath/"exit.c").write(<<-C
        #include <efi.h>
        #include <efilib.h>

        EFI_STATUS
        efi_main (EFI_HANDLE image_handle, EFI_SYSTEM_TABLE *systab)
        {
            InitializeLib(image_handle, systab);
            Exit(EFI_SUCCESS, 0, NULL);
            return EFI_UNSUPPORTED;
        }
    C
    )

    system "#{Formula["mingw-w64"].bin}/x86_64-w64-mingw32-gcc",
        "-I#{include}/efi", "-I#{include}/efi/x86_64",
        "-ffreestanding", "-L#{lib}",
        "-nostdlib", "-Wl,-dll", "-shared", "-Wl,--subsystem,10", "-Wl,-eefi_main", "-Wl,-Bsymbolic", "-Wl,-nostdlib",
        "exit.c", "-lgnuefi", "-lefi"
  end
end

__END__
diff --git a/Make.defaults b/Make.defaults
index ba743f1..1715979 100755
--- a/Make.defaults
+++ b/Make.defaults
@@ -46,18 +46,18 @@ TOPDIR := $(shell if [ "$$PWD" != "" ]; then echo $$PWD; else pwd; fi)
 # lib and include under the root
 #
 INSTALLROOT  := /
-PREFIX       := /usr/local
+PREFIX       ?= /usr/local
 LIBDIR 	     := $(PREFIX)/lib
 INSTALL	     := install
 
 # Compilation tools
-HOSTCC       := $(prefix)gcc
-CC           := $(prefix)$(CROSS_COMPILE)gcc
-AS           := $(prefix)$(CROSS_COMPILE)as
-LD           := $(prefix)$(CROSS_COMPILE)ld
-AR           := $(prefix)$(CROSS_COMPILE)ar
-RANLIB       := $(prefix)$(CROSS_COMPILE)ranlib
-OBJCOPY      := $(prefix)$(CROSS_COMPILE)objcopy
+HOSTCC       := gcc
+CC           := $(CROSS_COMPILE)gcc
+AS           := $(CROSS_COMPILE)as
+LD           := $(CROSS_COMPILE)ld
+AR           := $(CROSS_COMPILE)ar
+RANLIB       := $(CROSS_COMPILE)ranlib
+OBJCOPY      := $(CROSS_COMPILE)objcopy
 
 
 # Host/target identification
@@ -170,7 +170,7 @@ CFLAGS  += $(ARCH3264) -g -O2 -Wall -Wextra -Werror \
            -fshort-wchar -fno-strict-aliasing \
            -ffreestanding -fno-stack-protector
 else
-CFLAGS  += $(ARCH3264) -g -O2 -Wall -Wextra -Werror \
+CFLAGS  += $(ARCH3264) -g -O2 -Wall -Wextra \
            -fshort-wchar -fno-strict-aliasing \
 	   -ffreestanding -fno-stack-protector -fno-stack-check \
            -fno-stack-check \
diff --git a/gnuefi/elf.h b/gnuefi/elf.h
new file mode 100644
index 0000000..a2c2bd9
--- /dev/null
+++ b/gnuefi/elf.h
@@ -0,0 +1,101 @@
+#include <libelf/gelf.h>
+#define R_ARM_NONE 0
+#define R_ARM_PC24 1
+#define R_ARM_ABS32 2
+#define R_MIPS_NONE 0
+#define R_MIPS_16 1
+#define R_MIPS_32 2
+#define R_MIPS_REL32 3
+#define R_MIPS_26 4
+#define R_MIPS_HI16 5
+#define R_MIPS_LO16 6
+#define R_IA64_IMM64 0x23 /* symbol + addend, mov imm64 */
+#define R_PPC_ADDR32 1 /* 32bit absolute address */
+#define R_PPC64_ADDR64 38 /* doubleword64 S + A */
+#define R_SH_DIR32 1
+#define R_SPARC_64 32 /* Direct 64 bit */
+#define R_390_32 4 /* Direct 32 bit. */
+#define R_390_64 22 /* Direct 64 bit. */
+#define R_MIPS_64 18
+#define R_386_NONE 0
+#define R_386_32 1
+#define R_386_PC32 2
+#define R_386_GOT32 3
+#define R_386_PLT32 4
+#define R_386_COPY 5
+#define R_386_GLOB_DAT 6
+#define R_386_JMP_SLOT 7
+#define R_386_RELATIVE 8
+#define R_386_GOTOFF 9
+#define R_386_GOTPC 10
+#define R_386_32PLT 11
+#define R_386_TLS_TPOFF 14
+#define R_386_TLS_IE 15
+#define R_386_TLS_GOTIE 16
+#define R_386_TLS_LE 17
+#define R_386_TLS_GD 18
+#define R_386_TLS_LDM 19
+#define R_386_16 20
+#define R_386_PC16 21
+#define R_386_8 22
+#define R_386_PC8 23
+#define R_386_TLS_GD_32 24
+#define R_386_TLS_GD_PUSH 25
+#define R_386_TLS_GD_CALL 26
+#define R_386_TLS_GD_POP 27
+#define R_386_TLS_LDM_32 28
+#define R_386_TLS_LDM_PUSH 29
+#define R_386_TLS_LDM_CALL 30
+#define R_386_TLS_LDM_POP 31
+#define R_386_TLS_LDO_32 32
+#define R_386_TLS_IE_32 33
+#define R_386_TLS_LE_32 34
+#define R_386_TLS_DTPMOD32 35
+#define R_386_TLS_DTPOFF32 36
+#define R_386_TLS_TPOFF32 37
+#define R_386_SIZE32 38
+#define R_386_TLS_GOTDESC 39
+#define R_386_TLS_DESC_CALL 40
+#define R_386_TLS_DESC 41
+#define R_386_IRELATIVE 42
+#define R_386_NUM 43
+#define R_X86_64_NONE 0
+#define R_X86_64_64 1
+#define R_X86_64_PC32 2
+#define R_X86_64_GOT32 3
+#define R_X86_64_PLT32 4
+#define R_X86_64_COPY 5
+#define R_X86_64_GLOB_DAT 6
+#define R_X86_64_JUMP_SLOT 7
+#define R_X86_64_RELATIVE 8
+#define R_X86_64_GOTPCREL 9
+#define R_X86_64_32 10
+#define R_X86_64_32S 11
+#define R_X86_64_16 12
+#define R_X86_64_PC16 13
+#define R_X86_64_8 14
+#define R_X86_64_PC8 15
+#define R_X86_64_DTPMOD64 16
+#define R_X86_64_DTPOFF64 17
+#define R_X86_64_TPOFF64 18
+#define R_X86_64_TLSGD 19
+#define R_X86_64_TLSLD 20
+#define R_X86_64_DTPOFF32 21
+#define R_X86_64_GOTTPOFF 22
+#define R_X86_64_TPOFF32 23
+#define R_X86_64_PC64 24
+#define R_X86_64_GOTOFF64 25
+#define R_X86_64_GOTPC32 26
+#define R_X86_64_GOT64 27
+#define R_X86_64_GOTPCREL64 28
+#define R_X86_64_GOTPC64 29
+#define R_X86_64_GOTPLT64 30
+#define R_X86_64_PLTOFF64 31
+#define R_X86_64_SIZE32 32
+#define R_X86_64_SIZE64 33
+#define R_X86_64_GOTPC32_TLSDESC 34
+#define R_X86_64_TLSDESC_CALL 35
+#define R_X86_64_TLSDESC 36
+#define R_X86_64_IRELATIVE 37
+#define R_X86_64_RELATIVE64 38
+#define R_X86_64_NUM 39
