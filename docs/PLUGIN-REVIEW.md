# مراجعة الإضافات

| الفئة | المعنى | سلوك السكربت |
|---|---|---|
| `v2-reviewed` | بيانات npm تعلن اعتماد `@opencode/plugin` v2 أو تمت مراجعة المصدر بما يكفي | يدخل الوضع الآمن |
| `needs-review` | مصدر معروف لكن API أو متطلبات البيئة تحتاج تحققاً إضافياً | يحتاج `--allow-risky` |
| `unverified` | مصدر GitHub معروف بالاسم لكن entrypoint/API لم يُثبتا | يحتاج `--allow-risky` |
| `unresolved` | لا يوجد مصدر موثوق قابل للتثبيت | محجوب دائماً |

لا يكفي أن يحتوي المستودع على كلمة OpenCode. يجب أن يكون entrypoint متوافقاً مع API v2 وأن تعمل hooks/tools/events في نسخة OpenCode المستهدفة.

## تخصيص قوي دون تخمين

يتم التحكم في القائمة عبر `config/plugins.json`. الخيارات الخاصة بالإضافة لا توضع إلا إذا وثقها upstream داخل README أو schema. استخدم صيغة OpenCode v2 object form عند الحاجة:

```jsonc
{
  "plugins": [
    {
      "package": "opencode-tasks@1.0.0",
      "options": {
        "timezone": "UTC"
      }
    }
  ]
}
```

أي خيار غير موثق قد يسبب فشلاً صامتاً أو سلوكاً خاطئاً، لذلك لا يولده هذا المشروع تلقائياً.
