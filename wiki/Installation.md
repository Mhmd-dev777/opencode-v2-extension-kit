# التثبيت والاستخدام

هذا المشروع لا يثبت OpenCode نيابة عن المستخدم. يجب تثبيت OpenCode v2 من المصدر الرسمي أولاً، ثم تشغيل `doctor`. إذا لم يجد السكربت الأمر `opencode` أو اكتشف إصداراً غير v2 فسيتوقف قبل أي تغيير.

```bash
curl -fsSL https://raw.githubusercontent.com/Alqudimi/opencode-v2-extension-kit/main/bin/opencode-v2-extensions -o /tmp/opencode-v2-extensions
chmod +x /tmp/opencode-v2-extensions
/tmp/opencode-v2-extensions doctor
```

بعد تنزيل المستودع، يفضّل تشغيل السكربت من نسخة محلية حتى يمكن مراجعة manifest قبل التثبيت:

```bash
git clone https://github.com/Mhmd-dev777/opencode-v2-extension-kit.git
cd opencode-v2-extension-kit
./bin/opencode-v2-extensions status
./bin/opencode-v2-extensions install --dry-run
./bin/opencode-v2-extensions install
```

الوضع الآمن يثبت فقط الإضافات المصنفة `v2-reviewed`. استخدم `--allow-risky` فقط بعد مراجعة المصدر والكود في `config/plugins.json`. الأسماء التي لا يوجد لها مصدر موثوق تبقى محجوبة.

## الإزالة الكاملة

```bash
./bin/opencode-v2-extensions remove
```

الإزالة تقتصر على الإضافات التي سجل السكربت أنه أدارها. لا تحذف إعدادات OpenCode العامة ولا بيانات الجلسات.
