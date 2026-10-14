#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[0;33m'
plain='\033[0m'

easyxray_folder="${EASYXRAY_MAIN_FOLDER:=/usr/local/easyxray}"
easyxray_service="${EASYXRAY_SERVICE:=/etc/systemd/system}"

# Installer languages: exactly the set the panel ships (internal/web/translation),
# English first because it is the default. `<locale>:<name>`, shown in the menu.
INSTALL_LANGUAGES="en-US:English;ar-EG:العربية;fa-IR:فارسی;zh-CN:简体中文;zh-TW:繁體中文;ja-JP:日本語;ru-RU:Русский;vi-VN:Tiếng Việt;es-ES:Español;id-ID:Indonesian;uk-UA:Український;tr-TR:Türkçe;pt-BR:Português"

# Message catalogue: every user-facing string in this script goes through msg().
# An unknown key, or a locale we do not ship, falls back to English.
msg() {
    local __key="${1:-}"
    if [[ $# -gt 0 ]]; then shift; fi
    case "${INSTALL_LANG:-en-US}:${__key}" in
        # ---- ar-EG ----
        ar-EG:msg_lang_menu_title) echo "اختر لغة التثبيت:" ;;
        ar-EG:msg_lang_invalid) echo "اختيار غير صالح، سيتم الاحتفاظ باللغة الحالية." ;;
        ar-EG:msg_root_required) echo "خطأ فادح: يرجى تشغيل هذا السكربت بصلاحيات root" ;;
        ar-EG:msg_menu_title) echo "استخدامات قائمة تحكم easyxray (الأوامر الفرعية):" ;;
        ar-EG:msg_unsupported_arch) echo "معمارية CPU غير مدعومة!" ;;
        ar-EG:msg_arch) printf "المعمارية: %s\n" "$@" ;;
        ar-EG:msg_os_check_failed) echo "فشل التحقق من نظام التشغيل، يرجى التواصل مع المؤلف!" ;;
        ar-EG:msg_os_release) printf "إصدار نظام التشغيل هو: %s\n" "$@" ;;
        ar-EG:msg_cert_not_pem) echo "الشهادة أو المفتاح الخاص ليس ملف PEM قابلًا للقراءة" ;;
        ar-EG:msg_cert_key_mismatch) echo "المفتاح الخاص لا يطابق الشهادة" ;;
        ar-EG:msg_cert_file_unreadable) printf "ملف الشهادة مفقود أو فارغ أو غير قابل للقراءة: %s\n" "$@" ;;
        ar-EG:msg_cert_key_unreadable) printf "ملف المفتاح الخاص مفقود أو فارغ أو غير قابل للقراءة: %s\n" "$@" ;;
        ar-EG:msg_cert_cli_failed) printf "easyxray cert انتهى بالرمز %s: %s\n" "$@" ;;
        ar-EG:msg_cert_not_saved) printf "لم يحفظ البانل الشهادة (cert المخزّن=%s، key=%s)\n" "$@" ;;
        ar-EG:msg_result_write_failed) printf "تحذير: فشل كتابة %s.\n" "$@" ;;
        ar-EG:msg_result_written) printf "تمت كتابة نتيجة التثبيت في %s (الصلاحيات 600).\n" "$@" ;;
        ar-EG:msg_pg_pgdg_fallback) printf "PostgreSQL %s غير متاح لهذا النظام؛ سيتم تثبيت PostgreSQL الخاص بالتوزيعة بدلًا منه.\n" "$@" ;;
        ar-EG:msg_pg_distro_unsupported) printf "توزيعة غير مدعومة للتثبيت التلقائي لـ PostgreSQL: %s\n" "$@" ;;
        ar-EG:msg_pg_hba_warn) echo "تحذير: تعذّر تحديث pg_hba.conf؛ قد يرفض PostgreSQL تسجيل الدخول عبر TCP للبانل (مصادقة ident)." ;;
        ar-EG:msg_pg_cred_write_failed) printf "فشل كتابة بيانات اعتماد PostgreSQL في %s\n" "$@" ;;
        ar-EG:msg_pg_client_tools) echo "تثبيت أدوات عميل PostgreSQL (pg_dump/pg_restore) للنسخ الاحتياطي من داخل البانل..." ;;
        ar-EG:msg_acme_installing_ssl) echo "تثبيت acme.sh لإدارة شهادات SSL..." ;;
        ar-EG:msg_acme_failed) echo "فشل تثبيت acme.sh" ;;
        ar-EG:msg_acme_ok) echo "تم تثبيت acme.sh بنجاح" ;;
        ar-EG:msg_ssl_setup_start) echo "جارٍ إعداد شهادة SSL..." ;;
        ar-EG:msg_acme_failed_skip) echo "فشل تثبيت acme.sh، سيتم تخطي إعداد SSL" ;;
        ar-EG:msg_ssl_issuing_domain) printf "إصدار شهادة SSL لـ %s...\n" "$@" ;;
        ar-EG:msg_ssl_port80_note) echo "ملاحظة: يجب أن يكون المنفذ 80 مفتوحًا ومتاحًا من الإنترنت" ;;
        ar-EG:msg_ssl_issue_failed) printf "فشل إصدار الشهادة لـ %s\n" "$@" ;;
        ar-EG:msg_ssl_retry_hint) echo "تأكد من أن المنفذ 80 مفتوح وأعد المحاولة لاحقًا باستخدام: easyxray" ;;
        ar-EG:msg_ssl_install_failed) echo "فشل تثبيت الشهادة" ;;
        ar-EG:msg_ssl_installed) echo "تم تثبيت شهادة SSL وضبطها بنجاح!" ;;
        ar-EG:msg_cert_files_not_found) echo "لم يتم العثور على ملفات الشهادة" ;;
        ar-EG:msg_ipcert_setup) echo "جارٍ إعداد شهادة IP من Let's Encrypt (ملف shortlived)..." ;;
        ar-EG:msg_ipcert_validity_note) echo "ملاحظة: شهادات IP صالحة لمدة 6 أيام تقريبًا ويتم تجديدها تلقائيًا." ;;
        ar-EG:msg_ipcert_port_note) echo "المنفذ الافتراضي هو 80. إذا اخترت منفذًا آخر، تأكد من توجيه المنفذ 80 الخارجي إليه." ;;
        ar-EG:msg_ipv4_required) echo "عنوان IPv4 مطلوب" ;;
        ar-EG:msg_ipv4_invalid) printf "عنوان IPv4 غير صالح: %s\n" "$@" ;;
        ar-EG:msg_ipv6_included) printf "تضمين عنوان IPv6: %s\n" "$@" ;;
        ar-EG:msg_acme_port_prompt) echo "المنفذ المستخدم لمستمع ACME HTTP-01 (افتراضي 80):" ;;
        ar-EG:msg_port_invalid_fallback) echo "تم إدخال منفذ غير صالح. سيتم الرجوع إلى 80." ;;
        ar-EG:msg_port_using) printf "استخدام المنفذ %s للتحقق المستقل.\n" "$@" ;;
        ar-EG:msg_port_forward_note) printf "تذكير: لا يزال Let's Encrypt يتصل عبر المنفذ 80؛ وجّه المنفذ 80 الخارجي إلى %s.\n" "$@" ;;
        ar-EG:msg_port_in_use) printf "المنفذ %s مستخدم بالفعل.\n" "$@" ;;
        ar-EG:msg_port_busy_ni) printf "المنفذ %s مشغول؛ لا يمكن المتابعة في الوضع غير التفاعلي.\n" "$@" ;;
        ar-EG:msg_acme_port_retry_prompt) echo "أدخل منفذًا آخر لمستمع acme.sh المستقل (اتركه فارغًا للإلغاء):" ;;
        ar-EG:msg_port_busy) printf "المنفذ %s مشغول؛ لا يمكن المتابعة.\n" "$@" ;;
        ar-EG:msg_port_invalid) echo "تم إدخال منفذ غير صالح." ;;
        ar-EG:msg_port_free) printf "المنفذ %s متاح وجاهز للتحقق المستقل.\n" "$@" ;;
        ar-EG:msg_ipcert_issuing) printf "إصدار شهادة IP لـ %s...\n" "$@" ;;
        ar-EG:msg_ipcert_issue_failed) echo "فشل إصدار شهادة IP" ;;
        ar-EG:msg_ipcert_port_hint) printf "تأكد من أن المنفذ %s يمكن الوصول إليه (أو موجّه من المنفذ 80 الخارجي)\n" "$@" ;;
        ar-EG:msg_cert_issued_installing) echo "تم إصدار الشهادة بنجاح، جارٍ التثبيت..." ;;
        ar-EG:msg_cert_files_missing) echo "لم يتم العثور على ملفات الشهادة بعد التثبيت" ;;
        ar-EG:msg_cert_files_installed) echo "تم تثبيت ملفات الشهادة بنجاح" ;;
        ar-EG:msg_cert_paths_setting) echo "ضبط مسارات الشهادة للبانل..." ;;
        ar-EG:msg_cert_files_at) echo "ملفات الشهادة موجودة في:" ;;
        ar-EG:msg_cert_file) echo "ملف الشهادة:" ;;
        ar-EG:msg_cert_key) echo "ملف المفتاح الخاص:" ;;
        ar-EG:msg_cert_paths_ok) echo "تم تعيين مسارات الشهادة للوحة" ;;
        ar-EG:msg_ipcert_installed) echo "تم تثبيت شهادة IP وضبطها بنجاح!" ;;
        ar-EG:msg_ipcert_autorenew) echo "الشهادة صالحة لمدة 6 أيام تقريبًا، ويتم تجديدها تلقائيًا عبر مهمة cron في acme.sh." ;;
        ar-EG:msg_acme_autorenew) echo "سيقوم acme.sh بتجديد الشهادة وإعادة تحميل easyxray تلقائيًا قبل انتهاء صلاحيتها." ;;
        ar-EG:msg_acme_installing) echo "جارٍ تثبيت acme.sh..." ;;
        ar-EG:msg_ssl_mode_needs_domain) printf "يتطلب EASYXRAY_SSL_MODE=domain قيمة صالحة في EASYXRAY_DOMAIN (القيمة الحالية: %s).\n" "$@" ;;
        ar-EG:msg_domain_prompt) echo "يرجى إدخال اسم الدومين: " ;;
        ar-EG:msg_domain_empty) echo "اسم الدومين لا يمكن أن يكون فارغًا. يرجى المحاولة مرة أخرى." ;;
        ar-EG:msg_domain_invalid) echo "تنسيق الدومين غير صالح. يرجى إدخال اسم دومين صالح." ;;
        ar-EG:msg_domain_checking) printf "دومينك هو: %s، جارٍ التحقق منه...\n" "$@" ;;
        ar-EG:msg_cert_existing_reuse) printf "تم العثور على شهادة موجودة لـ %s، وسيتم إعادة استخدامها.\n" "$@" ;;
        ar-EG:msg_acme_state_incomplete) printf "تم العثور على حالة acme.sh غير مكتملة لـ %s (لا توجد ملفات شهادة صالحة)؛ سيتم تنظيفها وإعادة الإصدار.\n" "$@" ;;
        ar-EG:msg_domain_ready) echo "دومينك جاهز الآن لإصدار الشهادات..." ;;
        ar-EG:msg_acme_port_choose_prompt) echo "يرجى اختيار المنفذ الذي تريد استخدامه (الافتراضي هو 80):" ;;
        ar-EG:msg_port_input_invalid) printf "الإدخال %s غير صالح، سيتم استخدام المنفذ الافتراضي 80.\n" "$@" ;;
        ar-EG:msg_port_will_use) printf "سيتم استخدام المنفذ: %s لإصدار الشهادات. تأكد من أن هذا المنفذ مفتوح.\n" "$@" ;;
        ar-EG:msg_panel_stopping) echo "إيقاف البانل مؤقتًا..." ;;
        ar-EG:msg_cert_issue_failed_logs) echo "فشل إصدار الشهادة، يرجى مراجعة السجلات." ;;
        ar-EG:msg_cert_issue_succeeded) echo "نجح إصدار الشهادة، جارٍ تثبيت الشهادات..." ;;
        ar-EG:msg_cert_using_existing) echo "استخدام الشهادة الموجودة، جارٍ تثبيت الشهادات..." ;;
        ar-EG:msg_reloadcmd_default) echo "القيمة الافتراضية للخيار --reloadcmd في ACME هي:" ;;
        ar-EG:msg_reloadcmd_runs_on) echo "سيتم تنفيذ هذا الأمر عند كل إصدار وتجديد للشهادة." ;;
        ar-EG:msg_reloadcmd_modify_prompt) echo "هل تريد تعديل --reloadcmd لـ ACME؟ (y/n):" ;;
        ar-EG:msg_reloadcmd_preset) echo "إعداد مسبق: systemctl reload nginx ; systemctl restart easyxray" ;;
        ar-EG:msg_reloadcmd_custom) echo "أدخل الأمر الخاص بك" ;;
        ar-EG:msg_reloadcmd_keep_default) echo "الاحتفاظ بقيمة reloadcmd الافتراضية" ;;
        ar-EG:msg_reloadcmd_option_prompt) echo "اختر خيارًا:" ;;
        ar-EG:msg_reloadcmd_is_preset) echo "قيمة reloadcmd هي: systemctl reload nginx ; systemctl restart easyxray" ;;
        ar-EG:msg_reloadcmd_order) echo "يُفضّل وضع إعادة تشغيل easyxray في النهاية" ;;
        ar-EG:msg_reloadcmd_custom_prompt) echo "يرجى إدخال قيمة reloadcmd المخصصة:" ;;
        ar-EG:msg_reloadcmd_is) printf "قيمة reloadcmd هي: %s\n" "$@" ;;
        ar-EG:msg_reloadcmd_keeping) echo "الاحتفاظ بقيمة reloadcmd الافتراضية" ;;
        ar-EG:msg_cert_installed_autorenew) echo "نجح تثبيت الشهادة، جارٍ تفعيل التجديد التلقائي..." ;;
        ar-EG:msg_cert_install_failed_exit) echo "فشل تثبيت الشهادة، جارٍ الخروج." ;;
        ar-EG:msg_autorenew_issues) echo "واجه إعداد التجديد التلقائي مشكلات، تفاصيل الشهادة:" ;;
        ar-EG:msg_autorenew_ok) echo "نجح التجديد التلقائي، تفاصيل الشهادة:" ;;
        ar-EG:msg_cert_set_panel_prompt) echo "هل تريد ضبط هذه الشهادة للبانل؟ (y/n):" ;;
        ar-EG:msg_done_url) echo "رابط الوصول:" ;;
        ar-EG:msg_cert_restart) echo "ستُعاد تشغيل اللوحة لتطبيق شهادة SSL..." ;;
        ar-EG:msg_cert_rejected) echo "خطأ: رفضت اللوحة الشهادة الرقمية، لذا ستقدم اللوحة HTTP عاديًا." ;;
        ar-EG:msg_skip_panel_path) echo "تخطي تعيين مسار اللوحة." ;;
        ar-EG:msg_ssl_choose) echo "اختر طريقة إعداد شهادة SSL:" ;;
        ar-EG:msg_ssl_opt1) echo "Let's Encrypt للنطاق (صلاحية 90 يومًا، يتجدد تلقائيًا)" ;;
        ar-EG:msg_ssl_opt2) echo "Let's Encrypt لعنوان IP (صلاحية 6 أيام، يتجدد تلقائيًا)" ;;
        ar-EG:msg_ssl_opt3) echo "شهادة SSL مخصصة (المسار إلى ملفات موجودة)" ;;
        ar-EG:msg_ssl_opt4) echo "تخطي SSL (للمتقدمين - خلف وكيل عكسي أو نفق SSH فقط)" ;;
        ar-EG:msg_ssl_note_opts) echo "ملاحظة: الخياران 1 و 2 يتطلبان فتح المنفذ 80. الخيار 3 يتطلب مسارات يدوية." ;;
        ar-EG:msg_ssl_note_opt4) echo "ملاحظة: الخيار 4 يقدّم البانل عبر HTTP عادي - آمن فقط خلف nginx/Caddy أو نفق SSH." ;;
        ar-EG:msg_ssl_mode_unknown) printf "قيمة EASYXRAY_SSL_MODE غير معروفة: %s، سيتم استخدام none (HTTP) افتراضيًا.\n" "$@" ;;
        ar-EG:msg_ssl_pick) echo "اختر خيارًا (الافتراضي 2 لعنوان IP): " ;;
        ar-EG:msg_ssl_le_domain) echo "استخدام Let's Encrypt لشهادة الدومين..." ;;
        ar-EG:msg_ssl_domain_ok) printf "✓ تم ضبط شهادة SSL بنجاح مع الدومين: %s\n" "$@" ;;
        ar-EG:msg_ssl_domain_extract_failed) echo "ربما اكتمل إعداد SSL، لكن استخراج الدومين فشل" ;;
        ar-EG:msg_ssl_domain_failed) echo "فشل إعداد شهادة SSL في وضع الدومين." ;;
        ar-EG:msg_ssl_le_ip) echo "استخدام Let's Encrypt لشهادة IP (ملف shortlived)..." ;;
        ar-EG:msg_ipv4_confirm_prompt) printf "هل %s هو عنوان IPv4 العام الصحيح الوارد لهذا الخادم؟ [Default y]:\n" "$@" ;;
        ar-EG:msg_ipv4_prompt) echo "يرجى إدخال عنوان IPv4 العام لخادمك:" ;;
        ar-EG:msg_ipv4_invalid_retry) echo "عنوان IPv4 غير صالح. حاول مرة أخرى." ;;
        ar-EG:msg_ipv6_prompt) echo "هل لديك عنوان IPv6 تريد تضمينه؟ (اتركه فارغًا للتخطي):" ;;
        ar-EG:msg_ipcert_configured) echo "✓ تم ضبط شهادة IP من Let's Encrypt بنجاح" ;;
        ar-EG:msg_ipcert_setup_failed) echo "✗ فشل إعداد شهادة IP. تأكد من أن المنفذ 80 مفتوح." ;;
        ar-EG:msg_custom_cert_using) echo "استخدام شهادة مخصصة موجودة..." ;;
        ar-EG:msg_custom_cert_domain_prompt) echo "يرجى إدخال اسم الدومين الذي صدرت الشهادة له:" ;;
        ar-EG:msg_custom_cert_path_prompt) echo "أدخل مسار الشهادة (كلمات مفتاحية: .crt / fullchain):" ;;
        ar-EG:msg_file_missing) echo "خطأ: الملف غير موجود! حاول مرة أخرى." ;;
        ar-EG:msg_file_unreadable) echo "خطأ: الملف موجود لكنه غير قابل للقراءة (تحقق من الصلاحيات)!" ;;
        ar-EG:msg_file_empty) echo "خطأ: الملف فارغ!" ;;
        ar-EG:msg_custom_key_path_prompt) echo "أدخل مسار المفتاح الخاص (كلمات مفتاحية: .key / privatekey):" ;;
        ar-EG:msg_custom_cert_not_applied) echo "✗ لم يتم تطبيق الشهادة المخصصة -- سيعمل البانل عبر HTTP عادي." ;;
        ar-EG:msg_custom_cert_applied) echo "✓ تم تطبيق مسارات الشهادة المخصصة." ;;
        ar-EG:msg_custom_cert_renew_note) echo "ملاحظة: أنت مسؤول عن تجديد هذه الملفات خارجيًا." ;;
        ar-EG:msg_no_ssl_title) echo "⚠ سيتم تثبيت البانل بدون SSL/TLS." ;;
        ar-EG:msg_no_ssl_plaintext) echo "ستنتقل بيانات تسجيل الدخول والكوكيز عبر HTTP عادي." ;;
        ar-EG:msg_no_ssl_safe_when) echo "آمن فقط عندما:" ;;
        ar-EG:msg_no_ssl_proxy) echo "  • يوجد بروكسي عكسي (nginx, Caddy, Traefik) ينهي TLS نيابةً عنك، أو" ;;
        ar-EG:msg_no_ssl_tunnel) echo "  • تصل إلى البانل حصريًا عبر نفق SSH" ;;
        ar-EG:msg_bind_localhost_prompt) echo "ربط البانل بـ 127.0.0.1 فقط؟ (موصى به — يفرض الوصول عبر نفق SSH أو بروكسي عكسي) [y/N]:" ;;
        ar-EG:msg_panel_localhost_only) echo "✓ البانل مرتبط بـ 127.0.0.1 فقط. لم يعد يمكن الوصول إليه من الإنترنت العام." ;;
        ar-EG:msg_ssh_forward_title) echo "تمرير منفذ SSH — افتح البانل من جهازك المحلي عبر:" ;;
        ar-EG:msg_ssh_cmd_standard) echo "  أمر SSH القياسي:" ;;
        ar-EG:msg_ssh_cmd_key) echo "  في حال استخدام مفتاح SSH:" ;;
        ar-EG:msg_ssh_cmd_open) echo "  ثم افتح في المتصفح:" ;;
        ar-EG:msg_ssh_alt_proxy) printf "بديل: وجّه بروكسي عكسي (nginx/Caddy) إلى 127.0.0.1:%s ودعه ينهي TLS.\n" "$@" ;;
        ar-EG:msg_no_ssl_all_interfaces) echo "سيستمع البانل على كل الواجهات عبر HTTP عادي. تأكد من وجود شيء آخر ينهي TLS أمامه." ;;
        ar-EG:msg_ssl_skipped) echo "✓ تم تخطي إعداد SSL." ;;
        ar-EG:msg_ssl_option_invalid) echo "خيار غير صالح. سيتم تخطي إعداد SSL." ;;
        ar-EG:msg_ip_detect_failed) echo "تعذّر الكشف التلقائي عن عنوان IP للخادم من أي مصدر." ;;
        ar-EG:msg_db_selection_title) echo "اختيار قاعدة البيانات" ;;
        ar-EG:msg_db_opt_sqlite) echo "1) SQLite     (افتراضي — موصى به لأقل من 500 عميل)" ;;
        ar-EG:msg_db_opt_pg) echo "2) PostgreSQL (موصى به عند كثرة العملاء أو تعدد العقد)" ;;
        ar-EG:msg_choose_default) echo "اختر [1]:" ;;
        ar-EG:msg_db_label_pg_external) echo "PostgreSQL (خارجي)" ;;
        ar-EG:msg_pg_installing_local) echo "تثبيت PostgreSQL محليًا (غير تفاعلي)..." ;;
        ar-EG:msg_pg_failed_ni) echo "فشل تثبيت PostgreSQL في الوضع غير التفاعلي؛ سيتم الإلغاء." ;;
        ar-EG:msg_pg_env_hint) echo "اضبط EASYXRAY_DB_DSN لاستخدام خادم موجود، أو EASYXRAY_DB_TYPE=sqlite." ;;
        ar-EG:msg_pg_menu_local) echo "1) تثبيت PostgreSQL محليًا وإنشاء مستخدم وقاعدة بيانات مخصصين (موصى به)" ;;
        ar-EG:msg_pg_menu_external) echo "2) استخدام خادم PostgreSQL موجود (أدخل DSN)" ;;
        ar-EG:msg_pg_dsn_prompt) echo "أدخل DSN لـ PostgreSQL (postgres://user:pass@host:port/dbname?sslmode=disable):" ;;
        ar-EG:msg_pg_installing) echo "تثبيت PostgreSQL — قد يستغرق بعض الوقت..." ;;
        ar-EG:msg_pg_credfile_failed) echo "فشل إنشاء ملف بيانات اعتماد مؤقت." ;;
        ar-EG:msg_pg_failed) echo "فشل تثبيت PostgreSQL." ;;
        ar-EG:msg_pg_menu_retry) echo "1) إعادة محاولة التثبيت المحلي" ;;
        ar-EG:msg_pg_menu_dsn) echo "2) إدخال DSN خارجي بدلًا من ذلك" ;;
        ar-EG:msg_pg_menu_abort) echo "3) إلغاء التثبيت" ;;
        ar-EG:msg_pg_menu_fallback) echo "4) الرجوع إلى SQLite" ;;
        ar-EG:msg_install_aborted) echo "تم إلغاء التثبيت." ;;
        ar-EG:msg_pg_client_missing) echo "⚠ تعذّر تثبيت pg_dump/pg_restore. لن تتوفر ميزة النسخ الاحتياطي والاسترجاع داخل البانل حتى تثبّت حزمة postgresql-client." ;;
        ar-EG:msg_panel_port) printf "منفذ البانل الخاص بك هو: %s\n" "$@" ;;
        ar-EG:msg_panel_port_random) printf "تم توليد منفذ عشوائي: %s\n" "$@" ;;
        ar-EG:msg_panel_port_customize_prompt) echo "هل تريد تخصيص إعدادات منفذ البانل؟ (إن لم تفعل، سيتم تطبيق منفذ عشوائي) [y/n]:" ;;
        ar-EG:msg_panel_port_prompt) echo "يرجى ضبط منفذ البانل:" ;;
        ar-EG:msg_ssl_title) echo "إعداد شهادة SSL (موصى به)" ;;
        ar-EG:msg_ssl_recommend) echo "يوصى بشدة باستخدام SSL. تخطَّه فقط إذا كان الوكيل العكسي أو نفق SSH يتولى TLS نيابة عنك." ;;
        ar-EG:msg_ssl_le_note) echo "أصبح Let's Encrypt يدعم الآن النطاقات وعناوين IP معًا!" ;;
        ar-EG:msg_abort1) echo "تعذّر تطبيق الشهادة على اللوحة، لذا ستقدم HTTP عاديًا خلف رابط https://." ;;
        ar-EG:msg_abort2) echo "لم يتغير أي شيء آخر؛ أصلح الشهادة وأعد تشغيل المثبّت." ;;
        ar-EG:msg_done_title) echo "اكتمل تثبيت اللوحة!" ;;
        ar-EG:msg_done_user) echo "اسم المستخدم:" ;;
        ar-EG:msg_done_pass) echo "الباسورد:" ;;
        ar-EG:msg_done_port) echo "المنفذ:" ;;
        ar-EG:msg_done_wbp) echo "مسار الويب (WebBasePath):" ;;
        ar-EG:msg_done_db) echo "قاعدة البيانات:" ;;
        ar-EG:msg_done_token) echo "رمز API:" ;;
        ar-EG:msg_done_save) echo "مهم: احفظ هذه البيانات بأمان!" ;;
        ar-EG:msg_ssl_on) echo "شهادة SSL: مُفعّلة ومُهيّأة" ;;
        ar-EG:msg_ssl_off) echo "شهادة SSL: تم تخطيها - اللوحة تعمل على HTTP فقط. استخدم وكيلًا عكسيًا أو نفق SSH." ;;
        ar-EG:msg_pg_backup_title) echo "النسخ الاحتياطي والاسترجاع لـ PostgreSQL مدمجان في البانل:" ;;
        ar-EG:msg_pg_backup_menu) echo "→ النسخ الاحتياطي والاسترجاع" ;;
        ar-EG:msg_pg_backup_note) echo "  النسخ الاحتياطي ينزّل ملف .dump من pg_dump؛ والاسترجاع يعيد تحميله عبر pg_restore." ;;
        ar-EG:msg_pg_creds_title) echo "بيانات اعتماد PostgreSQL" ;;
        ar-EG:msg_pg_db_name) echo "اسم قاعدة البيانات:" ;;
        ar-EG:msg_pg_username) echo "اسم المستخدم:" ;;
        ar-EG:msg_pg_password) echo "كلمة المرور:" ;;
        ar-EG:msg_pg_host) echo "المضيف:" ;;
        ar-EG:msg_pg_port) echo "المنفذ:" ;;
        ar-EG:msg_pg_dsn) echo "DSN:" ;;
        ar-EG:msg_pg_env_file) echo "ملف المتغيرات:" ;;
        ar-EG:msg_pg_connect) echo "الاتصال من هذا الخادم:" ;;
        ar-EG:msg_pg_as_superuser) echo "(بصفة مستخدم postgres الفائق)" ;;
        ar-EG:msg_pg_env_read) printf "⚠ يقرأ البانل بيانات الاعتماد هذه من %s.\n" "$@" ;;
        ar-EG:msg_pg_save_password) echo "⚠ احفظ كلمة المرور — فهي غير مخزنة بنص صريح في أي مكان آخر." ;;
        ar-EG:msg_wbp_generating) echo "WebBasePath مفقود أو قصير جدًا. جارٍ توليد قيمة جديدة..." ;;
        ar-EG:msg_wbp_new) printf "WebBasePath الجديد: %s\n" "$@" ;;
        ar-EG:msg_default_creds) echo "تم اكتشاف بيانات اعتماد افتراضية. مطلوب تحديث أمني..." ;;
        ar-EG:msg_new_creds) echo "تم توليد بيانات اعتماد تسجيل دخول عشوائية جديدة:" ;;
        ar-EG:msg_creds_set) echo "تم ضبط اسم المستخدم وكلمة المرور و WebBasePath بشكل صحيح." ;;
        ar-EG:msg_ssl_already_configured) echo "شهادة SSL مضبوطة بالفعل. لا حاجة لأي إجراء." ;;
        ar-EG:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s، سيتم تخطي الإعداد التلقائي لـ Fail2ban.\n" "$@" ;;
        ar-EG:msg_f2b_skipped_cli) echo "لم يتم العثور على واجهة easyxray CLI؛ سيتم تخطي الإعداد التلقائي لـ Fail2ban." ;;
        ar-EG:msg_f2b_skipped_old) echo "ملف easyxray.sh هذا أقدم من الأمر easyxray setup-fail2ban؛ سيتم تخطي الإعداد التلقائي لـ Fail2ban." ;;
        ar-EG:msg_f2b_setup) echo "جارٍ إعداد Fail2ban لميزة تحديد IP..." ;;
        ar-EG:msg_f2b_done) echo "اكتمل إعداد Fail2ban." ;;
        ar-EG:msg_f2b_incomplete) echo "لم يكتمل إعداد Fail2ban؛ سيبقى تحديد IP معطلًا حتى تشغّل easyxray وتفتح قائمة تحديد IP. جارٍ المتابعة." ;;
        ar-EG:msg_systemd_hardening_note) printf "ملاحظة: يتجاهل systemd %s جزءًا من إجراءات التقوية في easyxray.service؛ ومع ذلك يبدأ البانل.\n" "$@" ;;
        ar-EG:msg_systemd_hardening_missing) printf "      لم يتم تطبيقه، يتطلب إصدارًا أحدث من systemd: %s.\n" "$@" ;;
        ar-EG:msg_systemd_hardening_alias) echo "      تبقى مجلدات البانل قابلة للكتابة عبر ReadWriteDirectories=، وهو الاسم البديل الذي يثبته هذا السكربت." ;;
        ar-EG:msg_systemd_hardening_rest) echo "      بقية إجراءات التقوية سارية. قم بترقية systemd لتطبيق ما سبق." ;;
        ar-EG:msg_ws_warn_head) echo "تحذير: هذه المجلدات تحتوي على مسافات وتم استبعادها من" ;;
        ar-EG:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf: %s\n" "$@" ;;
        ar-EG:msg_ws_warn_tail) echo "         لا يستطيع البانل الكتابة فيها تحت sandbox الوحدة." ;;
        ar-EG:msg_sandbox_refresh_failed) printf "تحذير: تعذّر تحديث %s/easyxray.service.d/10-easyxray-sandbox.conf.\n" "$@" ;;
        ar-EG:msg_sandbox_write_hint) echo "إذا كان EASYXRAY_DB_FOLDER أو EASYXRAY_LOG_FOLDER يشير إلى مسار خارج /etc/easyxray و /var/log/easyxray، فقد لا يتمكن البانل من الكتابة فيه تحت ProtectSystem=full." ;;
        ar-EG:msg_checksum_none) echo "لا يوجد مجموع اختباري منشور لهذا الإصدار، سيتم تخطي التحقق" ;;
        ar-EG:msg_checksum_download_failed) printf "فشل تنزيل المجموع الاختباري الخاص بـ %s (HTTP %s)\n" "$@" ;;
        ar-EG:msg_checksum_mismatch) printf "عدم تطابق المجموع الاختباري لـ %s: المتوقع %s، والفعلي %s\n" "$@" ;;
        ar-EG:msg_checksum_ok) printf "تم التحقق من المجموع الاختباري: %s\n" "$@" ;;
        ar-EG:msg_repo_file_missing) printf "%s غير متاح لـ %s (HTTP %s)\n" "$@" ;;
        ar-EG:msg_repo_file_missing_hint) echo "ثبّت إصدارًا يحتوي عليه، أو استخدم dev للبناء المتجدد. لم يتم المساس بتثبيتك الحالي." ;;
        ar-EG:msg_version_fetch_failed) echo "فشل جلب إصدار easyxray، قد يكون السبب قيود GitHub API، يرجى المحاولة لاحقًا" ;;
        ar-EG:msg_latest_version) printf "تم الحصول على أحدث إصدار من easyxray: %s، جارٍ بدء التثبيت...\n" "$@" ;;
        ar-EG:msg_download_failed) echo "فشل تنزيل easyxray، تأكد من أن خادمك يستطيع الوصول إلى GitHub" ;;
        ar-EG:msg_archive_empty) echo "أرشيف إصدار easyxray الذي تم تنزيله فارغ" ;;
        ar-EG:msg_dev_build) echo "تثبيت البناء المتجدد dev (الوسم: dev-latest). هذا إصدار أولي لكل commit وليس إصدارًا مستقرًا." ;;
        ar-EG:msg_install_start) echo "بدء تثبيت" ;;
        ar-EG:msg_download_version_failed) printf "فشل تنزيل easyxray %s، يرجى التأكد من وجود هذا الإصدار\n" "$@" ;;
        ar-EG:msg_script_download_failed) echo "فشل تنزيل easyxray.sh" ;;
        ar-EG:msg_script_empty) echo "ملف easyxray.sh الذي تم تنزيله فارغ" ;;
        ar-EG:msg_bin_backup_failed) echo "تعذّر أخذ نسخة احتياطية من bin/ -- لن يتم الاحتفاظ بالملفات المخصصة الموجودة فيه خلال هذا التحديث" ;;
        ar-EG:msg_extract_failed) echo "فشل استخراج أرشيف إصدار easyxray -- تمت إزالة التثبيت السابق بالفعل، لذا لن يبدأ البانل حتى يتم إصلاح ذلك؛ حاول تشغيل المثبّت مرة أخرى" ;;
        ar-EG:msg_binary_missing) echo "الأرشيف المستخرج من easyxray لا يحتوي على ملف easyxray التنفيذي -- تمت إزالة التثبيت السابق بالفعل، لذا لن يبدأ البانل حتى يتم إصلاح ذلك؛ حاول تشغيل المثبّت مرة أخرى" ;;
        ar-EG:msg_bin_restored) printf "تمت استعادة الملفات المخصصة في bin/ غير المضمّنة في هذا الإصدار: %s\n" "$@" ;;
        ar-EG:msg_script_install_failed) echo "فشل تثبيت easyxray.sh" ;;
        ar-EG:msg_gitignore_added) echo "تمت إضافة EasyXray.db إلى /etc/.gitignore لأجل etckeeper" ;;
        ar-EG:msg_gitignore_created) echo "تم إنشاء /etc/.gitignore وإضافة EasyXray.db لأجل etckeeper" ;;
        ar-EG:msg_rc_download_failed) echo "فشل تنزيل easyxray.rc" ;;
        ar-EG:msg_rc_empty) echo "ملف easyxray.rc الذي تم تنزيله فارغ" ;;
        ar-EG:msg_rc_install_failed) echo "فشل تثبيت easyxray.rc" ;;
        ar-EG:msg_service_found) echo "تم العثور على easyxray.service في الملفات المستخرجة، جارٍ التثبيت..." ;;
        ar-EG:msg_service_found_variant) printf "تم العثور على easyxray.service.%s في الملفات المستخرجة، جارٍ التثبيت...\n" "$@" ;;
        ar-EG:msg_service_downloading) echo "لم يتم العثور على ملفات الخدمة في tar.gz، جارٍ التنزيل من GitHub..." ;;
        ar-EG:msg_service_install_failed) printf "فشل تثبيت easyxray.service من GitHub (%s) -- لم يضم أرشيف الإصدار أي ملف منه كذلك\n" "$@" ;;
        ar-EG:msg_systemd_setup) echo "جارٍ إعداد وحدة systemd..." ;;
        ar-EG:msg_service_file_failed) echo "فشل تثبيت ملف easyxray.service" ;;
        ar-EG:msg_installed_ok) echo "انتهى التثبيت، وهو يعمل الآن..." ;;
        ar-EG:msg_running) echo "جارٍ التشغيل..." ;;
        ar-EG:msg_menu_admin) echo "سكربت إدارة المشرف" ;;
        ar-EG:msg_menu_start) echo "تشغيل" ;;
        ar-EG:msg_menu_stop) echo "إيقاف" ;;
        ar-EG:msg_menu_restart) echo "إعادة تشغيل" ;;
        ar-EG:msg_menu_status) echo "الحالة الحالية" ;;
        ar-EG:msg_menu_settings) echo "الإعدادات الحالية" ;;
        ar-EG:msg_menu_enable) echo "تفعيل التشغيل التلقائي عند بدء النظام" ;;
        ar-EG:msg_menu_disable) echo "تعطيل التشغيل التلقائي عند بدء النظام" ;;
        ar-EG:msg_menu_log) echo "مراجعة السجلات" ;;
        ar-EG:msg_menu_banlog) echo "مراجعة سجلات الحظر في Fail2ban" ;;
        ar-EG:msg_menu_update) echo "تحديث" ;;
        ar-EG:msg_menu_legacy) echo "الإصدار القديم" ;;
        ar-EG:msg_menu_install) echo "تثبيت" ;;
        ar-EG:msg_menu_uninstall) echo "إلغاء التثبيت" ;;
        # ---- fa-IR ----
        fa-IR:msg_lang_menu_title) echo "زبان نصب را انتخاب کنید:" ;;
        fa-IR:msg_lang_invalid) echo "انتخاب نامعتبر است، زبان فعلی حفظ می‌شود." ;;
        fa-IR:msg_root_required) echo "خطای مهلک: لطفاً این اسکریپت را با دسترسی root اجرا کنید" ;;
        fa-IR:msg_menu_title) echo "کاربردهای منوی کنترل easyxray (زیرفرمان‌ها):" ;;
        fa-IR:msg_unsupported_arch) echo "معماری CPU پشتیبانی نمی‌شود!" ;;
        fa-IR:msg_arch) printf "معماری: %s\n" "$@" ;;
        fa-IR:msg_os_check_failed) echo "بررسی سیستم‌عامل ناموفق بود، لطفاً با نویسنده تماس بگیرید!" ;;
        fa-IR:msg_os_release) printf "نسخه سیستم‌عامل این است: %s\n" "$@" ;;
        fa-IR:msg_cert_not_pem) echo "گواهی یا کلید خصوصی یک فایل PEM قابل خواندن نیست" ;;
        fa-IR:msg_cert_key_mismatch) echo "کلید خصوصی با گواهی مطابقت ندارد" ;;
        fa-IR:msg_cert_file_unreadable) printf "فایل گواهی موجود نیست، خالی است یا قابل خواندن نیست: %s\n" "$@" ;;
        fa-IR:msg_cert_key_unreadable) printf "فایل کلید خصوصی موجود نیست، خالی است یا قابل خواندن نیست: %s\n" "$@" ;;
        fa-IR:msg_cert_cli_failed) printf "easyxray cert با کد %s خارج شد: %s\n" "$@" ;;
        fa-IR:msg_cert_not_saved) printf "پنل گواهی را ذخیره نکرد (cert=%s، key=%s)\n" "$@" ;;
        fa-IR:msg_result_write_failed) printf "هشدار: نوشتن %s ناموفق بود.\n" "$@" ;;
        fa-IR:msg_result_written) printf "نتیجه نصب در %s نوشته شد (حالت 600).\n" "$@" ;;
        fa-IR:msg_pg_pgdg_fallback) printf "PostgreSQL %s برای این سیستم در دسترس نیست؛ در عوض PostgreSQL خود توزیع نصب می‌شود.\n" "$@" ;;
        fa-IR:msg_pg_distro_unsupported) printf "توزیع پشتیبانی‌نشده برای نصب خودکار PostgreSQL: %s\n" "$@" ;;
        fa-IR:msg_pg_hba_warn) echo "هشدار: به‌روزرسانی pg_hba.conf ممکن نشد؛ ممکن است PostgreSQL ورود TCP پنل را رد کند (احراز هویت ident)." ;;
        fa-IR:msg_pg_cred_write_failed) printf "نوشتن اطلاعات ورود PostgreSQL در %s ناموفق بود\n" "$@" ;;
        fa-IR:msg_pg_client_tools) echo "نصب ابزارهای کلاینت PostgreSQL (pg_dump/pg_restore) برای پشتیبان‌گیری از داخل پنل..." ;;
        fa-IR:msg_acme_installing_ssl) echo "نصب acme.sh برای مدیریت گواهی SSL..." ;;
        fa-IR:msg_acme_failed) echo "نصب acme.sh ناموفق بود" ;;
        fa-IR:msg_acme_ok) echo "acme.sh با موفقیت نصب شد" ;;
        fa-IR:msg_ssl_setup_start) echo "در حال راه‌اندازی گواهی SSL..." ;;
        fa-IR:msg_acme_failed_skip) echo "نصب acme.sh ناموفق بود، از راه‌اندازی SSL صرف‌نظر می‌شود" ;;
        fa-IR:msg_ssl_issuing_domain) printf "صدور گواهی SSL برای %s...\n" "$@" ;;
        fa-IR:msg_ssl_port80_note) echo "توجه: پورت 80 باید باز و از اینترنت قابل دسترس باشد" ;;
        fa-IR:msg_ssl_issue_failed) printf "صدور گواهی برای %s ناموفق بود\n" "$@" ;;
        fa-IR:msg_ssl_retry_hint) echo "لطفاً مطمئن شوید پورت 80 باز است و بعداً با دستور easyxray دوباره تلاش کنید" ;;
        fa-IR:msg_ssl_install_failed) echo "نصب گواهی ناموفق بود" ;;
        fa-IR:msg_ssl_installed) echo "گواهی SSL با موفقیت نصب و تنظیم شد!" ;;
        fa-IR:msg_cert_files_not_found) echo "فایل‌های گواهی یافت نشد" ;;
        fa-IR:msg_ipcert_setup) echo "در حال راه‌اندازی گواهی IP از Let's Encrypt (پروفایل shortlived)..." ;;
        fa-IR:msg_ipcert_validity_note) echo "توجه: گواهی‌های IP حدود 6 روز اعتبار دارند و خودکار تمدید می‌شوند." ;;
        fa-IR:msg_ipcert_port_note) echo "شنونده پیش‌فرض پورت 80 است. اگر پورت دیگری انتخاب کنید، مطمئن شوید پورت 80 خارجی به آن هدایت می‌شود." ;;
        fa-IR:msg_ipv4_required) echo "آدرس IPv4 الزامی است" ;;
        fa-IR:msg_ipv4_invalid) printf "آدرس IPv4 نامعتبر: %s\n" "$@" ;;
        fa-IR:msg_ipv6_included) printf "افزودن آدرس IPv6: %s\n" "$@" ;;
        fa-IR:msg_acme_port_prompt) echo "پورت مورد استفاده برای شنونده ACME HTTP-01 (پیش‌فرض 80):" ;;
        fa-IR:msg_port_invalid_fallback) echo "پورت واردشده نامعتبر است. بازگشت به 80." ;;
        fa-IR:msg_port_using) printf "استفاده از پورت %s برای اعتبارسنجی مستقل.\n" "$@" ;;
        fa-IR:msg_port_forward_note) printf "یادآوری: Let's Encrypt همچنان از طریق پورت 80 متصل می‌شود؛ پورت 80 خارجی را به %s هدایت کنید.\n" "$@" ;;
        fa-IR:msg_port_in_use) printf "پورت %s در حال استفاده است.\n" "$@" ;;
        fa-IR:msg_port_busy_ni) printf "پورت %s مشغول است؛ ادامه در حالت غیرتعاملی ممکن نیست.\n" "$@" ;;
        fa-IR:msg_acme_port_retry_prompt) echo "پورت دیگری برای شنونده مستقل acme.sh وارد کنید (برای لغو خالی بگذارید):" ;;
        fa-IR:msg_port_busy) printf "پورت %s مشغول است؛ ادامه ممکن نیست.\n" "$@" ;;
        fa-IR:msg_port_invalid) echo "پورت واردشده نامعتبر است." ;;
        fa-IR:msg_port_free) printf "پورت %s آزاد و آماده اعتبارسنجی مستقل است.\n" "$@" ;;
        fa-IR:msg_ipcert_issuing) printf "صدور گواهی IP برای %s...\n" "$@" ;;
        fa-IR:msg_ipcert_issue_failed) echo "صدور گواهی IP ناموفق بود" ;;
        fa-IR:msg_ipcert_port_hint) printf "لطفاً مطمئن شوید پورت %s قابل دسترسی است (یا از پورت 80 خارجی هدایت شده است)\n" "$@" ;;
        fa-IR:msg_cert_issued_installing) echo "گواهی با موفقیت صادر شد، در حال نصب..." ;;
        fa-IR:msg_cert_files_missing) echo "فایل‌های گواهی پس از نصب یافت نشد" ;;
        fa-IR:msg_cert_files_installed) echo "فایل‌های گواهی با موفقیت نصب شد" ;;
        fa-IR:msg_cert_paths_setting) echo "تنظیم مسیرهای گواهی برای پنل..." ;;
        fa-IR:msg_cert_files_at) echo "فایل‌های گواهی در این مسیرها هستند:" ;;
        fa-IR:msg_cert_file) echo "فایل گواهی:" ;;
        fa-IR:msg_cert_key) echo "فایل کلید خصوصی:" ;;
        fa-IR:msg_cert_paths_ok) echo "مسیرهای گواهی برای پنل تنظیم شد" ;;
        fa-IR:msg_ipcert_installed) echo "گواهی IP با موفقیت نصب و تنظیم شد!" ;;
        fa-IR:msg_ipcert_autorenew) echo "گواهی حدود 6 روز اعتبار دارد و از طریق کرون‌جاب acme.sh خودکار تمدید می‌شود." ;;
        fa-IR:msg_acme_autorenew) echo "acme.sh پیش از انقضا، گواهی را خودکار تمدید و easyxray را دوباره بارگذاری می‌کند." ;;
        fa-IR:msg_acme_installing) echo "در حال نصب acme.sh..." ;;
        fa-IR:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain به یک EASYXRAY_DOMAIN معتبر نیاز دارد (مقدار فعلی: %s).\n" "$@" ;;
        fa-IR:msg_domain_prompt) echo "لطفاً آدرس دامنه خود را وارد کنید: " ;;
        fa-IR:msg_domain_empty) echo "آدرس دامنه نمی‌تواند خالی باشد. لطفاً دوباره تلاش کنید." ;;
        fa-IR:msg_domain_invalid) echo "قالب دامنه نامعتبر است. لطفاً یک آدرس دامنه معتبر وارد کنید." ;;
        fa-IR:msg_domain_checking) printf "دامنه شما %s است، در حال بررسی...\n" "$@" ;;
        fa-IR:msg_cert_existing_reuse) printf "گواهی موجودی برای %s پیدا شد و دوباره استفاده می‌شود.\n" "$@" ;;
        fa-IR:msg_acme_state_incomplete) printf "وضعیت ناقص acme.sh برای %s پیدا شد (فایل گواهی معتبری وجود ندارد)؛ پاکسازی و صدور مجدد می‌شود.\n" "$@" ;;
        fa-IR:msg_domain_ready) echo "دامنه شما اکنون برای صدور گواهی آماده است..." ;;
        fa-IR:msg_acme_port_choose_prompt) echo "لطفاً انتخاب کنید کدام پورت استفاده شود (پیش‌فرض 80 است):" ;;
        fa-IR:msg_port_input_invalid) printf "ورودی %s نامعتبر است، از پورت پیش‌فرض 80 استفاده می‌شود.\n" "$@" ;;
        fa-IR:msg_port_will_use) printf "از پورت %s برای صدور گواهی استفاده می‌شود. لطفاً مطمئن شوید این پورت باز است.\n" "$@" ;;
        fa-IR:msg_panel_stopping) echo "توقف موقت پنل..." ;;
        fa-IR:msg_cert_issue_failed_logs) echo "صدور گواهی ناموفق بود، لطفاً لاگ‌ها را بررسی کنید." ;;
        fa-IR:msg_cert_issue_succeeded) echo "صدور گواهی موفق بود، در حال نصب گواهی‌ها..." ;;
        fa-IR:msg_cert_using_existing) echo "استفاده از گواهی موجود، در حال نصب گواهی‌ها..." ;;
        fa-IR:msg_reloadcmd_default) echo "مقدار پیش‌فرض --reloadcmd برای ACME این است:" ;;
        fa-IR:msg_reloadcmd_runs_on) echo "این دستور در هر صدور و تمدید گواهی اجرا می‌شود." ;;
        fa-IR:msg_reloadcmd_modify_prompt) echo "آیا می‌خواهید --reloadcmd مربوط به ACME را تغییر دهید؟ (y/n):" ;;
        fa-IR:msg_reloadcmd_preset) echo "پیش‌تنظیم: systemctl reload nginx ; systemctl restart easyxray" ;;
        fa-IR:msg_reloadcmd_custom) echo "دستور دلخواه خود را وارد کنید" ;;
        fa-IR:msg_reloadcmd_keep_default) echo "نگه داشتن reloadcmd پیش‌فرض" ;;
        fa-IR:msg_reloadcmd_option_prompt) echo "یک گزینه انتخاب کنید:" ;;
        fa-IR:msg_reloadcmd_is_preset) echo "مقدار reloadcmd این است: systemctl reload nginx ; systemctl restart easyxray" ;;
        fa-IR:msg_reloadcmd_order) echo "توصیه می‌شود ری‌استارت easyxray در انتها قرار گیرد" ;;
        fa-IR:msg_reloadcmd_custom_prompt) echo "لطفاً reloadcmd سفارشی خود را وارد کنید:" ;;
        fa-IR:msg_reloadcmd_is) printf "مقدار reloadcmd این است: %s\n" "$@" ;;
        fa-IR:msg_reloadcmd_keeping) echo "نگه داشتن reloadcmd پیش‌فرض" ;;
        fa-IR:msg_cert_installed_autorenew) echo "نصب گواهی موفق بود، در حال فعال‌سازی تمدید خودکار..." ;;
        fa-IR:msg_cert_install_failed_exit) echo "نصب گواهی ناموفق بود، خروج." ;;
        fa-IR:msg_autorenew_issues) echo "راه‌اندازی تمدید خودکار با مشکل مواجه شد، جزئیات گواهی:" ;;
        fa-IR:msg_autorenew_ok) echo "تمدید خودکار موفق بود، جزئیات گواهی:" ;;
        fa-IR:msg_cert_set_panel_prompt) echo "آیا می‌خواهید این گواهی را برای پنل تنظیم کنید؟ (y/n):" ;;
        fa-IR:msg_done_url) echo "نشانی دسترسی:" ;;
        fa-IR:msg_cert_restart) echo "پنل برای اعمال گواهی SSL راه‌اندازی مجدد می‌شود..." ;;
        fa-IR:msg_cert_rejected) echo "خطا: پنل گواهی دیجیتال را نپذیرفت، بنابراین پنل با HTTP ساده سرویس می‌داد." ;;
        fa-IR:msg_skip_panel_path) echo "از تنظیم مسیر پنل صرف‌نظر می‌شود." ;;
        fa-IR:msg_ssl_choose) echo "روش راه‌اندازی گواهی SSL را انتخاب کنید:" ;;
        fa-IR:msg_ssl_opt1) echo "Let's Encrypt برای دامنه (اعتبار ۹۰ روزه، تمدید خودکار)" ;;
        fa-IR:msg_ssl_opt2) echo "Let's Encrypt برای آدرس IP (اعتبار ۶ روزه، تمدید خودکار)" ;;
        fa-IR:msg_ssl_opt3) echo "گواهی SSL سفارشی (مسیر فایل‌های موجود)" ;;
        fa-IR:msg_ssl_opt4) echo "رد کردن SSL (پیشرفته - فقط پشت پروکسی معکوس یا تونل SSH)" ;;
        fa-IR:msg_ssl_note_opts) echo "توجه: گزینه‌های 1 و 2 به باز بودن پورت 80 نیاز دارند. گزینه 3 به مسیرهای دستی نیاز دارد." ;;
        fa-IR:msg_ssl_note_opt4) echo "توجه: گزینه 4 پنل را روی HTTP ساده ارائه می‌دهد - تنها پشت nginx/Caddy یا تونل SSH ایمن است." ;;
        fa-IR:msg_ssl_mode_unknown) printf "مقدار EASYXRAY_SSL_MODE ناشناخته است: %s، به‌صورت پیش‌فرض none (HTTP) استفاده می‌شود.\n" "$@" ;;
        fa-IR:msg_ssl_pick) echo "یک گزینه انتخاب کنید (پیش‌فرض ۲ برای IP): " ;;
        fa-IR:msg_ssl_le_domain) echo "استفاده از Let's Encrypt برای گواهی دامنه..." ;;
        fa-IR:msg_ssl_domain_ok) printf "✓ گواهی SSL با موفقیت برای دامنه تنظیم شد: %s\n" "$@" ;;
        fa-IR:msg_ssl_domain_extract_failed) echo "راه‌اندازی SSL احتمالاً کامل شده، اما استخراج دامنه ناموفق بود" ;;
        fa-IR:msg_ssl_domain_failed) echo "راه‌اندازی گواهی SSL در حالت دامنه ناموفق بود." ;;
        fa-IR:msg_ssl_le_ip) echo "استفاده از Let's Encrypt برای گواهی IP (پروفایل shortlived)..." ;;
        fa-IR:msg_ipv4_confirm_prompt) printf "آیا %s آدرس IPv4 عمومی ورودی صحیح برای این سرور است؟ [Default y]:\n" "$@" ;;
        fa-IR:msg_ipv4_prompt) echo "لطفاً آدرس IPv4 عمومی سرور خود را وارد کنید:" ;;
        fa-IR:msg_ipv4_invalid_retry) echo "آدرس IPv4 نامعتبر است. لطفاً دوباره تلاش کنید." ;;
        fa-IR:msg_ipv6_prompt) echo "آیا آدرس IPv6 برای افزودن دارید؟ (برای رد کردن خالی بگذارید):" ;;
        fa-IR:msg_ipcert_configured) echo "✓ گواهی IP از Let's Encrypt با موفقیت تنظیم شد" ;;
        fa-IR:msg_ipcert_setup_failed) echo "✗ راه‌اندازی گواهی IP ناموفق بود. لطفاً بررسی کنید پورت 80 باز است." ;;
        fa-IR:msg_custom_cert_using) echo "استفاده از گواهی سفارشی موجود..." ;;
        fa-IR:msg_custom_cert_domain_prompt) echo "لطفاً نام دامنه‌ای که گواهی برای آن صادر شده را وارد کنید:" ;;
        fa-IR:msg_custom_cert_path_prompt) echo "مسیر گواهی را وارد کنید (کلیدواژه‌ها: .crt / fullchain):" ;;
        fa-IR:msg_file_missing) echo "خطا: فایل وجود ندارد! دوباره تلاش کنید." ;;
        fa-IR:msg_file_unreadable) echo "خطا: فایل وجود دارد اما قابل خواندن نیست (مجوزها را بررسی کنید)!" ;;
        fa-IR:msg_file_empty) echo "خطا: فایل خالی است!" ;;
        fa-IR:msg_custom_key_path_prompt) echo "مسیر کلید خصوصی را وارد کنید (کلیدواژه‌ها: .key / privatekey):" ;;
        fa-IR:msg_custom_cert_not_applied) echo "✗ گواهی سفارشی اعمال نشد -- پنل روی HTTP ساده سرو می‌شد." ;;
        fa-IR:msg_custom_cert_applied) echo "✓ مسیرهای گواهی سفارشی اعمال شد." ;;
        fa-IR:msg_custom_cert_renew_note) echo "توجه: تمدید این فایل‌ها به‌صورت خارجی بر عهده شماست." ;;
        fa-IR:msg_no_ssl_title) echo "⚠ پنل بدون SSL/TLS نصب می‌شود." ;;
        fa-IR:msg_no_ssl_plaintext) echo "اطلاعات ورود و کوکی‌ها روی HTTP ساده منتقل می‌شوند." ;;
        fa-IR:msg_no_ssl_safe_when) echo "تنها در این حالت‌ها ایمن است:" ;;
        fa-IR:msg_no_ssl_proxy) echo "  • یک پراکسی معکوس (nginx, Caddy, Traefik) کار TLS را برای شما انجام دهد، یا" ;;
        fa-IR:msg_no_ssl_tunnel) echo "  • فقط از طریق تونل SSH به پنل دسترسی داشته باشید" ;;
        fa-IR:msg_bind_localhost_prompt) echo "پنل فقط به 127.0.0.1 متصل شود؟ (توصیه‌شده — دسترسی را به تونل SSH یا پراکسی معکوس محدود می‌کند) [y/N]:" ;;
        fa-IR:msg_panel_localhost_only) echo "✓ پنل فقط به 127.0.0.1 متصل شد. اکنون از اینترنت عمومی قابل دسترسی نیست." ;;
        fa-IR:msg_ssh_forward_title) echo "هدایت پورت SSH — پنل را از دستگاه محلی خود باز کنید با:" ;;
        fa-IR:msg_ssh_cmd_standard) echo "  دستور استاندارد SSH:" ;;
        fa-IR:msg_ssh_cmd_key) echo "  در صورت استفاده از کلید SSH:" ;;
        fa-IR:msg_ssh_cmd_open) echo "  سپس در مرورگر باز کنید:" ;;
        fa-IR:msg_ssh_alt_proxy) printf "جایگزین: یک پراکسی معکوس (nginx/Caddy) را به 127.0.0.1:%s اشاره دهید تا TLS را انجام دهد.\n" "$@" ;;
        fa-IR:msg_no_ssl_all_interfaces) echo "پنل روی همه واسط‌ها با HTTP ساده شنود می‌کند. مطمئن شوید چیز دیگری در جلوی آن TLS را انجام می‌دهد." ;;
        fa-IR:msg_ssl_skipped) echo "✓ راه‌اندازی SSL رد شد." ;;
        fa-IR:msg_ssl_option_invalid) echo "گزینه نامعتبر است. راه‌اندازی SSL رد می‌شود." ;;
        fa-IR:msg_ip_detect_failed) echo "تشخیص خودکار IP سرور از هیچ منبعی ممکن نشد." ;;
        fa-IR:msg_db_selection_title) echo "انتخاب پایگاه داده" ;;
        fa-IR:msg_db_opt_sqlite) echo "1) SQLite     (پیش‌فرض — توصیه‌شده برای کمتر از 500 کلاینت)" ;;
        fa-IR:msg_db_opt_pg) echo "2) PostgreSQL (توصیه‌شده برای تعداد زیاد کلاینت یا نودهای متعدد)" ;;
        fa-IR:msg_choose_default) echo "انتخاب کنید [1]:" ;;
        fa-IR:msg_db_label_pg_external) echo "PostgreSQL (خارجی)" ;;
        fa-IR:msg_pg_installing_local) echo "نصب محلی PostgreSQL (غیرتعاملی)..." ;;
        fa-IR:msg_pg_failed_ni) echo "نصب PostgreSQL در حالت غیرتعاملی ناموفق بود؛ لغو می‌شود." ;;
        fa-IR:msg_pg_env_hint) echo "برای استفاده از سرور موجود EASYXRAY_DB_DSN را تنظیم کنید، یا EASYXRAY_DB_TYPE=sqlite." ;;
        fa-IR:msg_pg_menu_local) echo "1) نصب محلی PostgreSQL و ساخت کاربر و پایگاه داده اختصاصی (توصیه‌شده)" ;;
        fa-IR:msg_pg_menu_external) echo "2) استفاده از سرور PostgreSQL موجود (وارد کردن DSN)" ;;
        fa-IR:msg_pg_dsn_prompt) echo "DSN برای PostgreSQL را وارد کنید (postgres://user:pass@host:port/dbname?sslmode=disable):" ;;
        fa-IR:msg_pg_installing) echo "در حال نصب PostgreSQL — ممکن است کمی طول بکشد..." ;;
        fa-IR:msg_pg_credfile_failed) echo "ساخت فایل موقت اطلاعات ورود ناموفق بود." ;;
        fa-IR:msg_pg_failed) echo "نصب PostgreSQL ناموفق بود." ;;
        fa-IR:msg_pg_menu_retry) echo "1) تلاش مجدد برای نصب محلی" ;;
        fa-IR:msg_pg_menu_dsn) echo "2) وارد کردن DSN خارجی" ;;
        fa-IR:msg_pg_menu_abort) echo "3) لغو نصب" ;;
        fa-IR:msg_pg_menu_fallback) echo "4) بازگشت به SQLite" ;;
        fa-IR:msg_install_aborted) echo "نصب لغو شد." ;;
        fa-IR:msg_pg_client_missing) echo "⚠ نصب pg_dump/pg_restore ممکن نشد. پشتیبان‌گیری و بازیابی پایگاه داده درون پنل تا زمان نصب بسته postgresql-client در دسترس نخواهد بود." ;;
        fa-IR:msg_panel_port) printf "پورت پنل شما: %s\n" "$@" ;;
        fa-IR:msg_panel_port_random) printf "پورت تصادفی تولید شد: %s\n" "$@" ;;
        fa-IR:msg_panel_port_customize_prompt) echo "آیا می‌خواهید تنظیمات پورت پنل را سفارشی کنید؟ (در غیر این صورت پورت تصادفی اعمال می‌شود) [y/n]:" ;;
        fa-IR:msg_panel_port_prompt) echo "لطفاً پورت پنل را تنظیم کنید:" ;;
        fa-IR:msg_ssl_title) echo "راه‌اندازی گواهی SSL (توصیه می‌شود)" ;;
        fa-IR:msg_ssl_recommend) echo "استفاده از SSL اکیداً توصیه می‌شود. فقط اگر پروکسی معکوس یا تونل SSH کار TLS را انجام می‌دهد آن را رد کنید." ;;
        fa-IR:msg_ssl_le_note) echo "Let's Encrypt اکنون از دامنه‌ها و آدرس‌های IP پشتیبانی می‌کند!" ;;
        fa-IR:msg_abort1) echo "گواهی روی پنل اعمال نشد، بنابراین با HTTP ساده پشت نشانی https:// سرویس می‌داد." ;;
        fa-IR:msg_abort2) echo "چیز دیگری تغییر نکرد؛ گواهی را اصلاح کنید و نصب‌کننده را دوباره اجرا کنید." ;;
        fa-IR:msg_done_title) echo "نصب پنل کامل شد!" ;;
        fa-IR:msg_done_user) echo "نام‌کاربری:" ;;
        fa-IR:msg_done_pass) echo "رمزعبور:" ;;
        fa-IR:msg_done_port) echo "پورت:" ;;
        fa-IR:msg_done_wbp) echo "مسیر پایه وب (WebBasePath):" ;;
        fa-IR:msg_done_db) echo "پایگاه داده:" ;;
        fa-IR:msg_done_token) echo "توکن API:" ;;
        fa-IR:msg_done_save) echo "مهم: این اطلاعات را در جای امنی ذخیره کنید!" ;;
        fa-IR:msg_ssl_on) echo "گواهی SSL: فعال و پیکربندی شده" ;;
        fa-IR:msg_ssl_off) echo "گواهی SSL: رد شد - پنل فقط HTTP است. از پروکسی معکوس یا تونل SSH استفاده کنید." ;;
        fa-IR:msg_pg_backup_title) echo "پشتیبان‌گیری و بازیابی PostgreSQL در خود پنل تعبیه شده است:" ;;
        fa-IR:msg_pg_backup_menu) echo "→ پشتیبان‌گیری و بازیابی" ;;
        fa-IR:msg_pg_backup_note) echo "  پشتیبان‌گیری یک فایل .dump از pg_dump دانلود می‌کند؛ بازیابی آن را با pg_restore بازمی‌گرداند." ;;
        fa-IR:msg_pg_creds_title) echo "اطلاعات ورود PostgreSQL" ;;
        fa-IR:msg_pg_db_name) echo "نام پایگاه داده:" ;;
        fa-IR:msg_pg_username) echo "نام کاربری:" ;;
        fa-IR:msg_pg_password) echo "رمز عبور:" ;;
        fa-IR:msg_pg_host) echo "میزبان:" ;;
        fa-IR:msg_pg_port) echo "پورت:" ;;
        fa-IR:msg_pg_dsn) echo "DSN:" ;;
        fa-IR:msg_pg_env_file) echo "فایل محیط:" ;;
        fa-IR:msg_pg_connect) echo "اتصال از این سرور:" ;;
        fa-IR:msg_pg_as_superuser) echo "(به‌عنوان ابرکاربر postgres)" ;;
        fa-IR:msg_pg_env_read) printf "⚠ پنل این اطلاعات ورود را از %s می‌خواند.\n" "$@" ;;
        fa-IR:msg_pg_save_password) echo "⚠ رمز عبور را ذخیره کنید — در جای دیگری به‌صورت متن ساده ذخیره نمی‌شود." ;;
        fa-IR:msg_wbp_generating) echo "WebBasePath وجود ندارد یا بسیار کوتاه است. در حال تولید مقدار جدید..." ;;
        fa-IR:msg_wbp_new) printf "WebBasePath جدید: %s\n" "$@" ;;
        fa-IR:msg_default_creds) echo "اطلاعات ورود پیش‌فرض شناسایی شد. به‌روزرسانی امنیتی لازم است..." ;;
        fa-IR:msg_new_creds) echo "اطلاعات ورود تصادفی جدید تولید شد:" ;;
        fa-IR:msg_creds_set) echo "نام کاربری، رمز عبور و WebBasePath به‌درستی تنظیم شدند." ;;
        fa-IR:msg_ssl_already_configured) echo "گواهی SSL از قبل تنظیم شده است. نیازی به اقدام نیست." ;;
        fa-IR:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s، راه‌اندازی خودکار Fail2ban رد می‌شود.\n" "$@" ;;
        fa-IR:msg_f2b_skipped_cli) echo "دستور easyxray CLI یافت نشد؛ راه‌اندازی خودکار Fail2ban رد می‌شود." ;;
        fa-IR:msg_f2b_skipped_old) echo "این easyxray.sh قدیمی‌تر از easyxray setup-fail2ban است؛ راه‌اندازی خودکار Fail2ban رد می‌شود." ;;
        fa-IR:msg_f2b_setup) echo "در حال راه‌اندازی Fail2ban برای قابلیت محدودیت IP..." ;;
        fa-IR:msg_f2b_done) echo "راه‌اندازی Fail2ban کامل شد." ;;
        fa-IR:msg_f2b_incomplete) echo "راه‌اندازی Fail2ban کامل نشد؛ محدودیت IP غیرفعال می‌ماند تا زمانی که easyxray را اجرا کنید و منوی محدودیت IP را باز کنید. ادامه داده می‌شود." ;;
        fa-IR:msg_systemd_hardening_note) printf "توجه: systemd %s بخشی از سخت‌سازی در easyxray.service را نادیده می‌گیرد؛ با این حال پنل اجرا می‌شود.\n" "$@" ;;
        fa-IR:msg_systemd_hardening_missing) printf "      اعمال نشد، به systemd جدیدتر نیاز دارد: %s.\n" "$@" ;;
        fa-IR:msg_systemd_hardening_alias) echo "      پوشه‌های پنل از طریق ReadWriteDirectories= که این اسکریپت نصب می‌کند قابل نوشتن می‌مانند." ;;
        fa-IR:msg_systemd_hardening_rest) echo "      بقیه سخت‌سازی اعمال شده است. برای اعمال موارد بالا systemd را ارتقا دهید." ;;
        fa-IR:msg_ws_warn_head) echo "هشدار: این پوشه‌ها فاصله دارند و از این فایل کنار گذاشته شدند" ;;
        fa-IR:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf: %s\n" "$@" ;;
        fa-IR:msg_ws_warn_tail) echo "         پنل نمی‌تواند تحت سندباکس این یونیت در آن‌ها بنویسد." ;;
        fa-IR:msg_sandbox_refresh_failed) printf "هشدار: به‌روزرسانی %s/easyxray.service.d/10-easyxray-sandbox.conf ممکن نشد.\n" "$@" ;;
        fa-IR:msg_sandbox_write_hint) echo "اگر EASYXRAY_DB_FOLDER یا EASYXRAY_LOG_FOLDER به خارج از /etc/easyxray و /var/log/easyxray اشاره کند، پنل ممکن است تحت ProtectSystem=full نتواند در آن بنویسد." ;;
        fa-IR:msg_checksum_none) echo "برای این نسخه چک‌سام منتشر نشده، بررسی رد می‌شود" ;;
        fa-IR:msg_checksum_download_failed) printf "دانلود چک‌سام برای %s ناموفق بود (HTTP %s)\n" "$@" ;;
        fa-IR:msg_checksum_mismatch) printf "عدم تطابق چک‌سام برای %s: انتظار %s، دریافت %s\n" "$@" ;;
        fa-IR:msg_checksum_ok) printf "چک‌سام تأیید شد: %s\n" "$@" ;;
        fa-IR:msg_repo_file_missing) printf "%s برای %s در دسترس نیست (HTTP %s)\n" "$@" ;;
        fa-IR:msg_repo_file_missing_hint) echo "نسخه‌ای که آن را همراه دارد نصب کنید، یا برای بیلد رولینگ dev را بزنید. نصب فعلی شما دست‌نخورده باقی مانده است." ;;
        fa-IR:msg_version_fetch_failed) echo "دریافت نسخه easyxray ناموفق بود، احتمالاً به دلیل محدودیت‌های GitHub API است، لطفاً بعداً تلاش کنید" ;;
        fa-IR:msg_latest_version) printf "آخرین نسخه easyxray دریافت شد: %s، شروع نصب...\n" "$@" ;;
        fa-IR:msg_download_failed) echo "دانلود easyxray ناموفق بود، لطفاً مطمئن شوید سرور شما به GitHub دسترسی دارد" ;;
        fa-IR:msg_archive_empty) echo "آرشیو نسخه easyxray دانلودشده خالی است" ;;
        fa-IR:msg_dev_build) echo "نصب بیلد رولینگ dev (تگ: dev-latest). این پیش‌انتشار برای هر کامیت است، نه یک نسخه پایدار." ;;
        fa-IR:msg_install_start) echo "شروع نصب" ;;
        fa-IR:msg_download_version_failed) printf "دانلود easyxray %s ناموفق بود، لطفاً بررسی کنید این نسخه وجود دارد\n" "$@" ;;
        fa-IR:msg_script_download_failed) echo "دانلود easyxray.sh ناموفق بود" ;;
        fa-IR:msg_script_empty) echo "فایل easyxray.sh دانلودشده خالی است" ;;
        fa-IR:msg_bin_backup_failed) echo "پشتیبان‌گیری از bin/ ممکن نشد -- فایل‌های سفارشی موجود در آن در این به‌روزرسانی حفظ نمی‌شوند" ;;
        fa-IR:msg_extract_failed) echo "استخراج آرشیو نسخه easyxray ناموفق بود -- نصب قبلی از قبل حذف شده است، بنابراین تا رفع این مشکل پنل اجرا نمی‌شود؛ دوباره نصب‌کننده را اجرا کنید" ;;
        fa-IR:msg_binary_missing) echo "آرشیو استخراج‌شده easyxray فایل اجرایی easyxray را ندارد -- نصب قبلی از قبل حذف شده است، بنابراین تا رفع این مشکل پنل اجرا نمی‌شود؛ دوباره نصب‌کننده را اجرا کنید" ;;
        fa-IR:msg_bin_restored) printf "فایل‌های سفارشی bin/ که در این نسخه ارائه نشده‌اند بازیابی شدند: %s\n" "$@" ;;
        fa-IR:msg_script_install_failed) echo "نصب easyxray.sh ناموفق بود" ;;
        fa-IR:msg_gitignore_added) echo "EasyXray.db برای etckeeper به /etc/.gitignore اضافه شد" ;;
        fa-IR:msg_gitignore_created) echo "/etc/.gitignore ساخته شد و EasyXray.db برای etckeeper اضافه شد" ;;
        fa-IR:msg_rc_download_failed) echo "دانلود easyxray.rc ناموفق بود" ;;
        fa-IR:msg_rc_empty) echo "فایل easyxray.rc دانلودشده خالی است" ;;
        fa-IR:msg_rc_install_failed) echo "نصب easyxray.rc ناموفق بود" ;;
        fa-IR:msg_service_found) echo "easyxray.service در فایل‌های استخراج‌شده پیدا شد، در حال نصب..." ;;
        fa-IR:msg_service_found_variant) printf "easyxray.service.%s در فایل‌های استخراج‌شده پیدا شد، در حال نصب...\n" "$@" ;;
        fa-IR:msg_service_downloading) echo "فایل‌های سرویس در tar.gz پیدا نشد، در حال دانلود از GitHub..." ;;
        fa-IR:msg_service_install_failed) printf "نصب easyxray.service از GitHub (%s) ناموفق بود -- آرشیو نسخه هم یکی از آن نداشت\n" "$@" ;;
        fa-IR:msg_systemd_setup) echo "در حال راه‌اندازی یونیت systemd..." ;;
        fa-IR:msg_service_file_failed) echo "نصب فایل easyxray.service ناموفق بود" ;;
        fa-IR:msg_installed_ok) echo "نصب به پایان رسید، هم‌اکنون در حال اجراست..." ;;
        fa-IR:msg_running) echo "در حال اجرا..." ;;
        fa-IR:msg_menu_admin) echo "اسکریپت مدیریت ادمین" ;;
        fa-IR:msg_menu_start) echo "شروع" ;;
        fa-IR:msg_menu_stop) echo "توقف" ;;
        fa-IR:msg_menu_restart) echo "راه‌اندازی مجدد" ;;
        fa-IR:msg_menu_status) echo "وضعیت فعلی" ;;
        fa-IR:msg_menu_settings) echo "تنظیمات فعلی" ;;
        fa-IR:msg_menu_enable) echo "فعال‌سازی اجرای خودکار هنگام راه‌اندازی سیستم" ;;
        fa-IR:msg_menu_disable) echo "غیرفعال‌سازی اجرای خودکار هنگام راه‌اندازی سیستم" ;;
        fa-IR:msg_menu_log) echo "بررسی لاگ‌ها" ;;
        fa-IR:msg_menu_banlog) echo "بررسی لاگ‌های مسدودسازی Fail2ban" ;;
        fa-IR:msg_menu_update) echo "به‌روزرسانی" ;;
        fa-IR:msg_menu_legacy) echo "نسخه قدیمی" ;;
        fa-IR:msg_menu_install) echo "نصب" ;;
        fa-IR:msg_menu_uninstall) echo "حذف نصب" ;;
        # ---- zh-CN ----
        zh-CN:msg_lang_menu_title) echo "选择安装语言：" ;;
        zh-CN:msg_lang_invalid) echo "选择无效，保留当前语言。" ;;
        zh-CN:msg_root_required) echo "致命错误：请以 root 权限运行此脚本" ;;
        zh-CN:msg_menu_title) echo "easyxray 控制菜单用法（子命令）：" ;;
        zh-CN:msg_unsupported_arch) echo "不支持的 CPU 架构！" ;;
        zh-CN:msg_arch) printf "架构：%s\n" "$@" ;;
        zh-CN:msg_os_check_failed) echo "无法检查系统操作系统，请联系作者！" ;;
        zh-CN:msg_os_release) printf "系统发行版本：%s\n" "$@" ;;
        zh-CN:msg_cert_not_pem) echo "证书或私钥不是可读的 PEM 文件" ;;
        zh-CN:msg_cert_key_mismatch) echo "私钥与证书不匹配" ;;
        zh-CN:msg_cert_file_unreadable) printf "证书文件缺失、为空或无法读取：%s\n" "$@" ;;
        zh-CN:msg_cert_key_unreadable) printf "私钥文件缺失、为空或无法读取：%s\n" "$@" ;;
        zh-CN:msg_cert_cli_failed) printf "easyxray cert 退出码 %s：%s\n" "$@" ;;
        zh-CN:msg_cert_not_saved) printf "面板未保存该证书（已存储 cert=%s，key=%s）\n" "$@" ;;
        zh-CN:msg_result_write_failed) printf "警告：写入 %s 失败。\n" "$@" ;;
        zh-CN:msg_result_written) printf "安装结果已写入 %s（权限 600）。\n" "$@" ;;
        zh-CN:msg_pg_pgdg_fallback) printf "PostgreSQL %s 不适用于当前系统；改为安装发行版自带的 PostgreSQL。\n" "$@" ;;
        zh-CN:msg_pg_distro_unsupported) printf "不支持自动安装 PostgreSQL 的发行版：%s\n" "$@" ;;
        zh-CN:msg_pg_hba_warn) echo "警告：无法更新 pg_hba.conf；PostgreSQL 可能拒绝面板的 TCP 登录（ident 认证）。" ;;
        zh-CN:msg_pg_cred_write_failed) printf "无法将 PostgreSQL 凭据写入 %s\n" "$@" ;;
        zh-CN:msg_pg_client_tools) echo "正在安装用于面板内备份的 PostgreSQL 客户端工具（pg_dump/pg_restore）..." ;;
        zh-CN:msg_acme_installing_ssl) echo "正在安装 acme.sh 以管理 SSL 证书..." ;;
        zh-CN:msg_acme_failed) echo "acme.sh 安装失败" ;;
        zh-CN:msg_acme_ok) echo "acme.sh 安装成功" ;;
        zh-CN:msg_ssl_setup_start) echo "正在配置 SSL 证书..." ;;
        zh-CN:msg_acme_failed_skip) echo "acme.sh 安装失败，跳过 SSL 配置" ;;
        zh-CN:msg_ssl_issuing_domain) printf "正在为 %s 签发 SSL 证书...\n" "$@" ;;
        zh-CN:msg_ssl_port80_note) echo "注意：80 端口必须对外开放且可被互联网访问" ;;
        zh-CN:msg_ssl_issue_failed) printf "为 %s 签发证书失败\n" "$@" ;;
        zh-CN:msg_ssl_retry_hint) echo "请确认 80 端口已开放，稍后使用以下命令重试：easyxray" ;;
        zh-CN:msg_ssl_install_failed) echo "证书安装失败" ;;
        zh-CN:msg_ssl_installed) echo "SSL 证书已成功安装并配置完成！" ;;
        zh-CN:msg_cert_files_not_found) echo "未找到证书文件" ;;
        zh-CN:msg_ipcert_setup) echo "正在配置 Let's Encrypt IP 证书（shortlived 配置）..." ;;
        zh-CN:msg_ipcert_validity_note) echo "注意：IP 证书有效期约为 6 天，并会自动续期。" ;;
        zh-CN:msg_ipcert_port_note) echo "默认监听 80 端口。若选择其他端口，请确保外部 80 端口转发到该端口。" ;;
        zh-CN:msg_ipv4_required) echo "必须提供 IPv4 地址" ;;
        zh-CN:msg_ipv4_invalid) printf "无效的 IPv4 地址：%s\n" "$@" ;;
        zh-CN:msg_ipv6_included) printf "一并包含 IPv6 地址：%s\n" "$@" ;;
        zh-CN:msg_acme_port_prompt) echo "ACME HTTP-01 监听使用端口（默认 80）：" ;;
        zh-CN:msg_port_invalid_fallback) echo "提供的端口无效。将回退到 80。" ;;
        zh-CN:msg_port_using) printf "使用端口 %s 进行独立验证。\n" "$@" ;;
        zh-CN:msg_port_forward_note) printf "提醒：Let's Encrypt 仍会连接 80 端口；请将外部 80 端口转发到 %s。\n" "$@" ;;
        zh-CN:msg_port_in_use) printf "端口 %s 已被占用。\n" "$@" ;;
        zh-CN:msg_port_busy_ni) printf "端口 %s 被占用；非交互模式下无法继续。\n" "$@" ;;
        zh-CN:msg_acme_port_retry_prompt) echo "为 acme.sh 独立监听输入另一个端口（留空则中止）：" ;;
        zh-CN:msg_port_busy) printf "端口 %s 被占用；无法继续。\n" "$@" ;;
        zh-CN:msg_port_invalid) echo "提供的端口无效。" ;;
        zh-CN:msg_port_free) printf "端口 %s 空闲，可用于独立验证。\n" "$@" ;;
        zh-CN:msg_ipcert_issuing) printf "正在为 %s 签发 IP 证书...\n" "$@" ;;
        zh-CN:msg_ipcert_issue_failed) echo "IP 证书签发失败" ;;
        zh-CN:msg_ipcert_port_hint) printf "请确保端口 %s 可访问（或已从外部 80 端口转发）\n" "$@" ;;
        zh-CN:msg_cert_issued_installing) echo "证书签发成功，正在安装..." ;;
        zh-CN:msg_cert_files_missing) echo "安装后仍未找到证书文件" ;;
        zh-CN:msg_cert_files_installed) echo "证书文件安装成功" ;;
        zh-CN:msg_cert_paths_setting) echo "正在为面板设置证书路径..." ;;
        zh-CN:msg_cert_files_at) echo "证书文件位于：" ;;
        zh-CN:msg_cert_file) echo "证书文件：" ;;
        zh-CN:msg_cert_key) echo "私钥文件：" ;;
        zh-CN:msg_cert_paths_ok) echo "已为面板设置证书路径" ;;
        zh-CN:msg_ipcert_installed) echo "IP 证书已成功安装并配置完成！" ;;
        zh-CN:msg_ipcert_autorenew) echo "证书有效期约 6 天，将通过 acme.sh 定时任务自动续期。" ;;
        zh-CN:msg_acme_autorenew) echo "acme.sh 会在证书到期前自动续期并重载 easyxray。" ;;
        zh-CN:msg_acme_installing) echo "正在安装 acme.sh..." ;;
        zh-CN:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain 需要有效的 EASYXRAY_DOMAIN（当前为：%s）。\n" "$@" ;;
        zh-CN:msg_domain_prompt) echo "请输入域名：" ;;
        zh-CN:msg_domain_empty) echo "域名不能为空，请重试。" ;;
        zh-CN:msg_domain_invalid) echo "域名格式无效，请输入正确的域名。" ;;
        zh-CN:msg_domain_checking) printf "你的域名为：%s，正在检查...\n" "$@" ;;
        zh-CN:msg_cert_existing_reuse) printf "已找到 %s 的现有证书，将直接复用。\n" "$@" ;;
        zh-CN:msg_acme_state_incomplete) printf "发现 %s 的 acme.sh 状态不完整（没有有效的证书文件）；正在清理并重新签发。\n" "$@" ;;
        zh-CN:msg_domain_ready) echo "你的域名已就绪，现在可以签发证书..." ;;
        zh-CN:msg_acme_port_choose_prompt) echo "请选择要使用的端口（默认为 80）：" ;;
        zh-CN:msg_port_input_invalid) printf "输入 %s 无效，将使用默认端口 80。\n" "$@" ;;
        zh-CN:msg_port_will_use) printf "将使用端口：%s 签发证书。请确保该端口已开放。\n" "$@" ;;
        zh-CN:msg_panel_stopping) echo "正在临时停止面板..." ;;
        zh-CN:msg_cert_issue_failed_logs) echo "证书签发失败，请检查日志。" ;;
        zh-CN:msg_cert_issue_succeeded) echo "证书签发成功，正在安装证书..." ;;
        zh-CN:msg_cert_using_existing) echo "使用现有证书，正在安装证书..." ;;
        zh-CN:msg_reloadcmd_default) echo "ACME 的默认 --reloadcmd 为：" ;;
        zh-CN:msg_reloadcmd_runs_on) echo "该命令会在每次签发和续期证书时执行。" ;;
        zh-CN:msg_reloadcmd_modify_prompt) echo "是否要修改 ACME 的 --reloadcmd？(y/n)：" ;;
        zh-CN:msg_reloadcmd_preset) echo "预设：systemctl reload nginx ; systemctl restart easyxray" ;;
        zh-CN:msg_reloadcmd_custom) echo "自行输入命令" ;;
        zh-CN:msg_reloadcmd_keep_default) echo "保留默认 reloadcmd" ;;
        zh-CN:msg_reloadcmd_option_prompt) echo "请选择一个选项：" ;;
        zh-CN:msg_reloadcmd_is_preset) echo "reloadcmd 为：systemctl reload nginx ; systemctl restart easyxray" ;;
        zh-CN:msg_reloadcmd_order) echo "建议将 easyxray 的重启放在最后" ;;
        zh-CN:msg_reloadcmd_custom_prompt) echo "请输入自定义的 reloadcmd：" ;;
        zh-CN:msg_reloadcmd_is) printf "reloadcmd 为：%s\n" "$@" ;;
        zh-CN:msg_reloadcmd_keeping) echo "保留默认 reloadcmd" ;;
        zh-CN:msg_cert_installed_autorenew) echo "证书安装成功，正在启用自动续期..." ;;
        zh-CN:msg_cert_install_failed_exit) echo "证书安装失败，即将退出。" ;;
        zh-CN:msg_autorenew_issues) echo "自动续期配置出现问题，证书详情：" ;;
        zh-CN:msg_autorenew_ok) echo "自动续期成功，证书详情：" ;;
        zh-CN:msg_cert_set_panel_prompt) echo "是否将此证书设置为面板的证书？(y/n)：" ;;
        zh-CN:msg_done_url) echo "访问地址：" ;;
        zh-CN:msg_cert_restart) echo "面板将重启以应用 SSL 证书..." ;;
        zh-CN:msg_cert_rejected) echo "错误：面板拒绝了该证书，面板将只能以明文 HTTP 提供服务。" ;;
        zh-CN:msg_skip_panel_path) echo "已跳过面板证书路径设置。" ;;
        zh-CN:msg_ssl_choose) echo "请选择 SSL 证书配置方式：" ;;
        zh-CN:msg_ssl_opt1) echo "为域名申请 Let's Encrypt 证书（90 天有效期，自动续期）" ;;
        zh-CN:msg_ssl_opt2) echo "为 IP 地址申请 Let's Encrypt 证书（6 天有效期，自动续期）" ;;
        zh-CN:msg_ssl_opt3) echo "自定义 SSL 证书（填写现有文件路径）" ;;
        zh-CN:msg_ssl_opt4) echo "跳过 SSL（高级：仅限反向代理 / SSH 隧道场景）" ;;
        zh-CN:msg_ssl_note_opts) echo "注意：选项 1 和 2 需要开放 80 端口。选项 3 需要手动填写路径。" ;;
        zh-CN:msg_ssl_note_opt4) echo "注意：选项 4 使用明文 HTTP 提供面板服务 - 仅在 nginx/Caddy 或 SSH 隧道之后才安全。" ;;
        zh-CN:msg_ssl_mode_unknown) printf "未知的 EASYXRAY_SSL_MODE=%s，将默认使用 none（HTTP）。\n" "$@" ;;
        zh-CN:msg_ssl_pick) echo "请选择 [默认 2：IP 证书]：" ;;
        zh-CN:msg_ssl_le_domain) echo "正在使用 Let's Encrypt 签发域名证书..." ;;
        zh-CN:msg_ssl_domain_ok) printf "✓ SSL 证书已配置成功，域名：%s\n" "$@" ;;
        zh-CN:msg_ssl_domain_extract_failed) echo "SSL 配置可能已完成，但域名提取失败" ;;
        zh-CN:msg_ssl_domain_failed) echo "域名模式的 SSL 证书配置失败。" ;;
        zh-CN:msg_ssl_le_ip) echo "正在使用 Let's Encrypt 签发 IP 证书（shortlived 配置）..." ;;
        zh-CN:msg_ipv4_confirm_prompt) printf "%s 是此服务器正确的传入公网 IPv4 地址吗？[Default y]：\n" "$@" ;;
        zh-CN:msg_ipv4_prompt) echo "请输入你服务器的公网 IPv4 地址：" ;;
        zh-CN:msg_ipv4_invalid_retry) echo "IPv4 地址无效。请重试。" ;;
        zh-CN:msg_ipv6_prompt) echo "是否有要包含的 IPv6 地址？（留空则跳过）：" ;;
        zh-CN:msg_ipcert_configured) echo "✓ Let's Encrypt IP 证书配置成功" ;;
        zh-CN:msg_ipcert_setup_failed) echo "✗ IP 证书配置失败。请检查 80 端口是否开放。" ;;
        zh-CN:msg_custom_cert_using) echo "正在使用自定义的现有证书..." ;;
        zh-CN:msg_custom_cert_domain_prompt) echo "请输入证书签发的域名：" ;;
        zh-CN:msg_custom_cert_path_prompt) echo "输入证书路径（关键词：.crt / fullchain）：" ;;
        zh-CN:msg_file_missing) echo "错误：文件不存在！请重试。" ;;
        zh-CN:msg_file_unreadable) echo "错误：文件存在但不可读（请检查权限）！" ;;
        zh-CN:msg_file_empty) echo "错误：文件为空！" ;;
        zh-CN:msg_custom_key_path_prompt) echo "输入私钥路径（关键词：.key / privatekey）：" ;;
        zh-CN:msg_custom_cert_not_applied) echo "✗ 自定义证书未生效 -- 面板将以明文 HTTP 提供服务。" ;;
        zh-CN:msg_custom_cert_applied) echo "✓ 自定义证书路径已生效。" ;;
        zh-CN:msg_custom_cert_renew_note) echo "注意：你需要自行在外部续期这些文件。" ;;
        zh-CN:msg_no_ssl_title) echo "⚠ 面板将在不启用 SSL/TLS 的情况下安装。" ;;
        zh-CN:msg_no_ssl_plaintext) echo "登录凭据和 Cookie 将以明文 HTTP 传输。" ;;
        zh-CN:msg_no_ssl_safe_when) echo "仅在以下情况才安全：" ;;
        zh-CN:msg_no_ssl_proxy) echo "  • 由反向代理（nginx、Caddy、Traefik）为你处理 TLS，或" ;;
        zh-CN:msg_no_ssl_tunnel) echo "  • 你仅通过 SSH 隧道访问面板" ;;
        zh-CN:msg_bind_localhost_prompt) echo "是否仅将面板绑定到 127.0.0.1？（推荐 — 强制通过 SSH 隧道 / 反向代理访问）[y/N]：" ;;
        zh-CN:msg_panel_localhost_only) echo "✓ 面板仅绑定 127.0.0.1。现已无法从公网访问。" ;;
        zh-CN:msg_ssh_forward_title) echo "SSH 端口转发 — 可通过以下方式在本机打开面板：" ;;
        zh-CN:msg_ssh_cmd_standard) echo "  标准 SSH 命令：" ;;
        zh-CN:msg_ssh_cmd_key) echo "  如果使用 SSH 密钥：" ;;
        zh-CN:msg_ssh_cmd_open) echo "  然后在浏览器中打开：" ;;
        zh-CN:msg_ssh_alt_proxy) printf "备选方案：将反向代理（nginx/Caddy）指向 127.0.0.1:%s，由它处理 TLS。\n" "$@" ;;
        zh-CN:msg_no_ssl_all_interfaces) echo "面板将在所有接口上以明文 HTTP 监听。请确保在其前端有其他服务处理 TLS。" ;;
        zh-CN:msg_ssl_skipped) echo "✓ 已跳过 SSL 配置。" ;;
        zh-CN:msg_ssl_option_invalid) echo "选项无效。跳过 SSL 配置。" ;;
        zh-CN:msg_ip_detect_failed) echo "无法从任何服务商自动探测服务器 IP。" ;;
        zh-CN:msg_db_selection_title) echo "数据库选择" ;;
        zh-CN:msg_db_opt_sqlite) echo "1) SQLite     （默认 — 推荐用于少于 500 个客户端）" ;;
        zh-CN:msg_db_opt_pg) echo "2) PostgreSQL（客户端数量多 / 节点数量多时推荐）" ;;
        zh-CN:msg_choose_default) echo "请选择 [1]：" ;;
        zh-CN:msg_db_label_pg_external) echo "PostgreSQL（外部）" ;;
        zh-CN:msg_pg_installing_local) echo "正在本地安装 PostgreSQL（非交互模式）..." ;;
        zh-CN:msg_pg_failed_ni) echo "非交互模式下 PostgreSQL 安装失败；正在中止。" ;;
        zh-CN:msg_pg_env_hint) echo "请设置 EASYXRAY_DB_DSN 以使用现有服务器，或设置 EASYXRAY_DB_TYPE=sqlite。" ;;
        zh-CN:msg_pg_menu_local) echo "1) 在本地安装 PostgreSQL 并创建专用的用户和数据库（推荐）" ;;
        zh-CN:msg_pg_menu_external) echo "2) 使用现有的 PostgreSQL 服务器（输入 DSN）" ;;
        zh-CN:msg_pg_dsn_prompt) echo "请输入 PostgreSQL DSN（postgres://user:pass@host:port/dbname?sslmode=disable）：" ;;
        zh-CN:msg_pg_installing) echo "正在安装 PostgreSQL — 这可能需要一些时间..." ;;
        zh-CN:msg_pg_credfile_failed) echo "创建临时凭据文件失败。" ;;
        zh-CN:msg_pg_failed) echo "PostgreSQL 安装失败。" ;;
        zh-CN:msg_pg_menu_retry) echo "1) 重试本地安装" ;;
        zh-CN:msg_pg_menu_dsn) echo "2) 改为输入外部 DSN" ;;
        zh-CN:msg_pg_menu_abort) echo "3) 中止安装" ;;
        zh-CN:msg_pg_menu_fallback) echo "4) 回退到 SQLite" ;;
        zh-CN:msg_install_aborted) echo "安装已中止。" ;;
        zh-CN:msg_pg_client_missing) echo "⚠ 无法安装 pg_dump/pg_restore。在安装 postgresql-client 软件包之前，面板内的数据库备份/恢复将无法使用。" ;;
        zh-CN:msg_panel_port) printf "你的面板端口为：%s\n" "$@" ;;
        zh-CN:msg_panel_port_random) printf "已生成随机端口：%s\n" "$@" ;;
        zh-CN:msg_panel_port_customize_prompt) echo "是否要自定义面板端口设置？（若不自定义，将应用随机端口）[y/n]：" ;;
        zh-CN:msg_panel_port_prompt) echo "请设置面板端口：" ;;
        zh-CN:msg_ssl_title) echo "SSL 证书配置（强烈推荐）" ;;
        zh-CN:msg_ssl_recommend) echo "强烈建议启用 SSL。仅当由反向代理或 SSH 隧道负责 TLS 时才跳过。" ;;
        zh-CN:msg_ssl_le_note) echo "Let's Encrypt 现已支持域名和 IP 地址！" ;;
        zh-CN:msg_abort1) echo "无法把证书应用到面板，若继续将出现「https:// 地址背后实际是明文 HTTP」的情况。" ;;
        zh-CN:msg_abort2) echo "其余内容未做任何改动；请修复证书后重新运行安装脚本。" ;;
        zh-CN:msg_done_title) echo "面板安装完成！" ;;
        zh-CN:msg_done_user) echo "用户名：" ;;
        zh-CN:msg_done_pass) echo "密码：" ;;
        zh-CN:msg_done_port) echo "端口：" ;;
        zh-CN:msg_done_wbp) echo "面板路径：" ;;
        zh-CN:msg_done_db) echo "数据库：" ;;
        zh-CN:msg_done_token) echo "API 令牌：" ;;
        zh-CN:msg_done_save) echo "重要：请妥善保存以上凭据！" ;;
        zh-CN:msg_ssl_on) echo "SSL 证书：已启用并配置完成" ;;
        zh-CN:msg_ssl_off) echo "SSL 证书：已跳过 —— 面板仅提供 HTTP，请配合反向代理或 SSH 隧道使用。" ;;
        zh-CN:msg_pg_backup_title) echo "面板内置了 PostgreSQL 备份与恢复功能：" ;;
        zh-CN:msg_pg_backup_menu) echo "→ 备份和恢复" ;;
        zh-CN:msg_pg_backup_note) echo "  「备份」会下载 pg_dump 生成的 .dump 文件；「恢复」则通过 pg_restore 重新载入。" ;;
        zh-CN:msg_pg_creds_title) echo "PostgreSQL 凭据" ;;
        zh-CN:msg_pg_db_name) echo "数据库名：" ;;
        zh-CN:msg_pg_username) echo "用户名：" ;;
        zh-CN:msg_pg_password) echo "密码：" ;;
        zh-CN:msg_pg_host) echo "主机：" ;;
        zh-CN:msg_pg_port) echo "端口：" ;;
        zh-CN:msg_pg_dsn) echo "DSN：" ;;
        zh-CN:msg_pg_env_file) echo "环境变量文件：" ;;
        zh-CN:msg_pg_connect) echo "从本服务器连接：" ;;
        zh-CN:msg_pg_as_superuser) echo "（以 postgres 超级用户身份）" ;;
        zh-CN:msg_pg_env_read) printf "⚠ 面板从 %s 读取这些凭据。\n" "$@" ;;
        zh-CN:msg_pg_save_password) echo "⚠ 请保存密码 — 它不会以明文形式存放在其他任何地方。" ;;
        zh-CN:msg_wbp_generating) echo "WebBasePath 缺失或过短。正在生成新的路径..." ;;
        zh-CN:msg_wbp_new) printf "新的 WebBasePath：%s\n" "$@" ;;
        zh-CN:msg_default_creds) echo "检测到默认凭据。需要更新安全设置..." ;;
        zh-CN:msg_new_creds) echo "已生成新的随机登录凭据：" ;;
        zh-CN:msg_creds_set) echo "用户名、密码和 WebBasePath 均已正确设置。" ;;
        zh-CN:msg_ssl_already_configured) echo "SSL 证书已配置。无需操作。" ;;
        zh-CN:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s，跳过 Fail2ban 自动配置。\n" "$@" ;;
        zh-CN:msg_f2b_skipped_cli) echo "未找到 easyxray CLI；跳过 Fail2ban 自动配置。" ;;
        zh-CN:msg_f2b_skipped_old) echo "此 easyxray.sh 早于 easyxray setup-fail2ban 子命令；跳过 Fail2ban 自动配置。" ;;
        zh-CN:msg_f2b_setup) echo "正在为 IP 限制功能配置 Fail2ban..." ;;
        zh-CN:msg_f2b_done) echo "Fail2ban 配置完成。" ;;
        zh-CN:msg_f2b_incomplete) echo "Fail2ban 配置未完成；在你运行 easyxray 并打开 IP 限制菜单之前，IP 限制将保持禁用。继续执行。" ;;
        zh-CN:msg_systemd_hardening_note) printf "注意：systemd %s 会忽略 easyxray.service 中的部分加固配置；面板仍可启动。\n" "$@" ;;
        zh-CN:msg_systemd_hardening_missing) printf "      未生效，需要更新的 systemd：%s。\n" "$@" ;;
        zh-CN:msg_systemd_hardening_alias) echo "      面板的目录通过本脚本安装的别名 ReadWriteDirectories= 保持可写。" ;;
        zh-CN:msg_systemd_hardening_rest) echo "      其余加固配置均已生效。升级 systemd 后可应用上述配置。" ;;
        zh-CN:msg_ws_warn_head) echo "警告：以下目录包含空白字符，未被写入" ;;
        zh-CN:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf：%s\n" "$@" ;;
        zh-CN:msg_ws_warn_tail) echo "         面板在单元的沙箱下无法写入这些目录。" ;;
        zh-CN:msg_sandbox_refresh_failed) printf "警告：无法刷新 %s/easyxray.service.d/10-easyxray-sandbox.conf。\n" "$@" ;;
        zh-CN:msg_sandbox_write_hint) echo "如果 EASYXRAY_DB_FOLDER 或 EASYXRAY_LOG_FOLDER 指向 /etc/easyxray 和 /var/log/easyxray 之外，在 ProtectSystem=full 下，面板可能无法写入。" ;;
        zh-CN:msg_checksum_none) echo "此版本未发布校验和，跳过验证" ;;
        zh-CN:msg_checksum_download_failed) printf "下载 %s 的校验和失败（HTTP %s）\n" "$@" ;;
        zh-CN:msg_checksum_mismatch) printf "%s 的校验和不匹配：期望 %s，实际为 %s\n" "$@" ;;
        zh-CN:msg_checksum_ok) printf "校验和验证通过：%s\n" "$@" ;;
        zh-CN:msg_repo_file_missing) printf "%s 不适用于 %s（HTTP %s）\n" "$@" ;;
        zh-CN:msg_repo_file_missing_hint) echo "请安装包含该文件的发行版本，或使用 dev 滚动构建。你现有的安装未被改动。" ;;
        zh-CN:msg_version_fetch_failed) echo "获取 easyxray 版本失败，可能是 GitHub API 访问受限，请稍后重试" ;;
        zh-CN:msg_latest_version) printf "已获取 easyxray 最新版本：%s，开始安装...\n" "$@" ;;
        zh-CN:msg_download_failed) echo "下载 easyxray 失败，请确认你的服务器可以访问 GitHub" ;;
        zh-CN:msg_archive_empty) echo "下载的 easyxray 发行包为空" ;;
        zh-CN:msg_dev_build) echo "正在安装滚动 dev 构建（标签：dev-latest）。这是按提交发布的预发布版本，并非稳定版本。" ;;
        zh-CN:msg_install_start) echo "开始安装" ;;
        zh-CN:msg_download_version_failed) printf "下载 easyxray %s 失败，请检查该版本是否存在\n" "$@" ;;
        zh-CN:msg_script_download_failed) echo "下载 easyxray.sh 失败" ;;
        zh-CN:msg_script_empty) echo "下载的 easyxray.sh 为空" ;;
        zh-CN:msg_bin_backup_failed) echo "无法备份 bin/ -- 其中的自定义文件在本次更新中不会被保留" ;;
        zh-CN:msg_extract_failed) echo "解压 easyxray 发行包失败 -- 之前的安装已被移除，因此在修复前面板无法启动；请尝试重新运行安装程序" ;;
        zh-CN:msg_binary_missing) echo "解压后的 easyxray 包中缺少 easyxray 二进制文件 -- 之前的安装已被移除，因此在修复前面板无法启动；请尝试重新运行安装程序" ;;
        zh-CN:msg_bin_restored) printf "已恢复 bin/ 中本版本未包含的自定义文件：%s\n" "$@" ;;
        zh-CN:msg_script_install_failed) echo "安装 easyxray.sh 失败" ;;
        zh-CN:msg_gitignore_added) echo "已将 EasyXray.db 添加到 /etc/.gitignore 以供 etckeeper 使用" ;;
        zh-CN:msg_gitignore_created) echo "已创建 /etc/.gitignore 并添加 EasyXray.db 以供 etckeeper 使用" ;;
        zh-CN:msg_rc_download_failed) echo "下载 easyxray.rc 失败" ;;
        zh-CN:msg_rc_empty) echo "下载的 easyxray.rc 为空" ;;
        zh-CN:msg_rc_install_failed) echo "安装 easyxray.rc 失败" ;;
        zh-CN:msg_service_found) echo "在解压文件中找到 easyxray.service，正在安装..." ;;
        zh-CN:msg_service_found_variant) printf "在解压文件中找到 easyxray.service.%s，正在安装...\n" "$@" ;;
        zh-CN:msg_service_downloading) echo "tar.gz 中未找到服务文件，正在从 GitHub 下载..." ;;
        zh-CN:msg_service_install_failed) printf "无法从 GitHub 安装 easyxray.service（%s）-- 发行包中也没有附带该文件\n" "$@" ;;
        zh-CN:msg_systemd_setup) echo "正在配置 systemd 单元..." ;;
        zh-CN:msg_service_file_failed) echo "安装 easyxray.service 文件失败" ;;
        zh-CN:msg_installed_ok) echo "安装完成，面板正在运行..." ;;
        zh-CN:msg_running) echo "运行中..." ;;
        zh-CN:msg_menu_admin) echo "管理脚本" ;;
        zh-CN:msg_menu_start) echo "启动" ;;
        zh-CN:msg_menu_stop) echo "停止" ;;
        zh-CN:msg_menu_restart) echo "重启" ;;
        zh-CN:msg_menu_status) echo "当前状态" ;;
        zh-CN:msg_menu_settings) echo "当前设置" ;;
        zh-CN:msg_menu_enable) echo "设置开机自启动" ;;
        zh-CN:msg_menu_disable) echo "取消开机自启动" ;;
        zh-CN:msg_menu_log) echo "查看日志" ;;
        zh-CN:msg_menu_banlog) echo "查看 Fail2ban 封禁日志" ;;
        zh-CN:msg_menu_update) echo "更新" ;;
        zh-CN:msg_menu_legacy) echo "旧版本" ;;
        zh-CN:msg_menu_install) echo "安装" ;;
        zh-CN:msg_menu_uninstall) echo "卸载" ;;
        # ---- zh-TW ----
        zh-TW:msg_lang_menu_title) echo "選擇安裝語言：" ;;
        zh-TW:msg_lang_invalid) echo "選擇無效，保留目前語言。" ;;
        zh-TW:msg_root_required) echo "致命錯誤：請以 root 權限執行此腳本" ;;
        zh-TW:msg_menu_title) echo "easyxray 控制選單用法（子命令）：" ;;
        zh-TW:msg_unsupported_arch) echo "不支援的 CPU 架構！" ;;
        zh-TW:msg_arch) printf "架構：%s\n" "$@" ;;
        zh-TW:msg_os_check_failed) echo "無法檢查系統作業系統，請聯絡作者！" ;;
        zh-TW:msg_os_release) printf "系統發行版本：%s\n" "$@" ;;
        zh-TW:msg_cert_not_pem) echo "憑證或私鑰不是可讀取的 PEM 檔案" ;;
        zh-TW:msg_cert_key_mismatch) echo "私鑰與憑證不相符" ;;
        zh-TW:msg_cert_file_unreadable) printf "憑證檔案缺失、為空或無法讀取：%s\n" "$@" ;;
        zh-TW:msg_cert_key_unreadable) printf "私鑰檔案缺失、為空或無法讀取：%s\n" "$@" ;;
        zh-TW:msg_cert_cli_failed) printf "easyxray cert 結束碼 %s：%s\n" "$@" ;;
        zh-TW:msg_cert_not_saved) printf "面板未儲存該憑證（已儲存 cert=%s，key=%s）\n" "$@" ;;
        zh-TW:msg_result_write_failed) printf "警告：寫入 %s 失敗。\n" "$@" ;;
        zh-TW:msg_result_written) printf "安裝結果已寫入 %s（權限 600）。\n" "$@" ;;
        zh-TW:msg_pg_pgdg_fallback) printf "PostgreSQL %s 不適用於此系統；改為安裝發行版內建的 PostgreSQL。\n" "$@" ;;
        zh-TW:msg_pg_distro_unsupported) printf "不支援自動安裝 PostgreSQL 的發行版：%s\n" "$@" ;;
        zh-TW:msg_pg_hba_warn) echo "警告：無法更新 pg_hba.conf；PostgreSQL 可能拒絕面板的 TCP 登入（ident 認證）。" ;;
        zh-TW:msg_pg_cred_write_failed) printf "無法將 PostgreSQL 認證資料寫入 %s\n" "$@" ;;
        zh-TW:msg_pg_client_tools) echo "正在安裝用於面板內備份的 PostgreSQL 用戶端工具（pg_dump/pg_restore）..." ;;
        zh-TW:msg_acme_installing_ssl) echo "正在安裝 acme.sh 以管理 SSL 憑證..." ;;
        zh-TW:msg_acme_failed) echo "acme.sh 安裝失敗" ;;
        zh-TW:msg_acme_ok) echo "acme.sh 安裝成功" ;;
        zh-TW:msg_ssl_setup_start) echo "正在設定 SSL 憑證..." ;;
        zh-TW:msg_acme_failed_skip) echo "acme.sh 安裝失敗，略過 SSL 設定" ;;
        zh-TW:msg_ssl_issuing_domain) printf "正在為 %s 簽發 SSL 憑證...\n" "$@" ;;
        zh-TW:msg_ssl_port80_note) echo "注意：80 連接埠必須對外開放且可從網際網路存取" ;;
        zh-TW:msg_ssl_issue_failed) printf "為 %s 簽發憑證失敗\n" "$@" ;;
        zh-TW:msg_ssl_retry_hint) echo "請確認 80 連接埠已開放，稍後使用下列命令重試：easyxray" ;;
        zh-TW:msg_ssl_install_failed) echo "憑證安裝失敗" ;;
        zh-TW:msg_ssl_installed) echo "SSL 憑證已成功安裝並設定完成！" ;;
        zh-TW:msg_cert_files_not_found) echo "找不到憑證檔案" ;;
        zh-TW:msg_ipcert_setup) echo "正在設定 Let's Encrypt IP 憑證（shortlived 設定檔）..." ;;
        zh-TW:msg_ipcert_validity_note) echo "注意：IP 憑證有效期約為 6 天，並會自動續期。" ;;
        zh-TW:msg_ipcert_port_note) echo "預設監聽 80 連接埠。若選擇其他連接埠，請確認外部 80 連接埠會轉送到該連接埠。" ;;
        zh-TW:msg_ipv4_required) echo "必須提供 IPv4 位址" ;;
        zh-TW:msg_ipv4_invalid) printf "無效的 IPv4 位址：%s\n" "$@" ;;
        zh-TW:msg_ipv6_included) printf "一併包含 IPv6 位址：%s\n" "$@" ;;
        zh-TW:msg_acme_port_prompt) echo "ACME HTTP-01 監聽使用連接埠（預設 80）：" ;;
        zh-TW:msg_port_invalid_fallback) echo "提供的連接埠無效。將退回使用 80。" ;;
        zh-TW:msg_port_using) printf "使用連接埠 %s 進行獨立驗證。\n" "$@" ;;
        zh-TW:msg_port_forward_note) printf "提醒：Let's Encrypt 仍會連線 80 連接埠；請將外部 80 連接埠轉送到 %s。\n" "$@" ;;
        zh-TW:msg_port_in_use) printf "連接埠 %s 已被占用。\n" "$@" ;;
        zh-TW:msg_port_busy_ni) printf "連接埠 %s 被占用；非互動模式下無法繼續。\n" "$@" ;;
        zh-TW:msg_acme_port_retry_prompt) echo "為 acme.sh 獨立監聽輸入另一個連接埠（留空則中止）：" ;;
        zh-TW:msg_port_busy) printf "連接埠 %s 被占用；無法繼續。\n" "$@" ;;
        zh-TW:msg_port_invalid) echo "提供的連接埠無效。" ;;
        zh-TW:msg_port_free) printf "連接埠 %s 閒置，可用於獨立驗證。\n" "$@" ;;
        zh-TW:msg_ipcert_issuing) printf "正在為 %s 簽發 IP 憑證...\n" "$@" ;;
        zh-TW:msg_ipcert_issue_failed) echo "IP 憑證簽發失敗" ;;
        zh-TW:msg_ipcert_port_hint) printf "請確認連接埠 %s 可連線（或已從外部 80 連接埠轉送）\n" "$@" ;;
        zh-TW:msg_cert_issued_installing) echo "憑證簽發成功，正在安裝..." ;;
        zh-TW:msg_cert_files_missing) echo "安裝後仍找不到憑證檔案" ;;
        zh-TW:msg_cert_files_installed) echo "憑證檔案安裝成功" ;;
        zh-TW:msg_cert_paths_setting) echo "正在為面板設定憑證路徑..." ;;
        zh-TW:msg_cert_files_at) echo "憑證檔案位於：" ;;
        zh-TW:msg_cert_file) echo "憑證檔案：" ;;
        zh-TW:msg_cert_key) echo "私密金鑰檔案：" ;;
        zh-TW:msg_cert_paths_ok) echo "已為面板設定憑證路徑" ;;
        zh-TW:msg_ipcert_installed) echo "IP 憑證已成功安裝並設定完成！" ;;
        zh-TW:msg_ipcert_autorenew) echo "憑證有效期約 6 天，將透過 acme.sh 排程工作自動續期。" ;;
        zh-TW:msg_acme_autorenew) echo "acme.sh 會在憑證到期前自動續期並重新載入 easyxray。" ;;
        zh-TW:msg_acme_installing) echo "正在安裝 acme.sh..." ;;
        zh-TW:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain 需要有效的 EASYXRAY_DOMAIN（目前為：%s）。\n" "$@" ;;
        zh-TW:msg_domain_prompt) echo "請輸入網域名稱：" ;;
        zh-TW:msg_domain_empty) echo "網域名稱不能為空，請重試。" ;;
        zh-TW:msg_domain_invalid) echo "網域格式無效，請輸入正確的網域名稱。" ;;
        zh-TW:msg_domain_checking) printf "你的域名為：%s，正在檢查...\n" "$@" ;;
        zh-TW:msg_cert_existing_reuse) printf "已找到 %s 的現有憑證，將直接沿用。\n" "$@" ;;
        zh-TW:msg_acme_state_incomplete) printf "發現 %s 的 acme.sh 狀態不完整（沒有有效的憑證檔案）；正在清理並重新簽發。\n" "$@" ;;
        zh-TW:msg_domain_ready) echo "你的域名已就緒，現在可以簽發憑證..." ;;
        zh-TW:msg_acme_port_choose_prompt) echo "請選擇要使用的連接埠（預設為 80）：" ;;
        zh-TW:msg_port_input_invalid) printf "輸入 %s 無效，將使用預設連接埠 80。\n" "$@" ;;
        zh-TW:msg_port_will_use) printf "將使用連接埠：%s 簽發憑證。請確認該連接埠已開放。\n" "$@" ;;
        zh-TW:msg_panel_stopping) echo "正在暫時停止面板..." ;;
        zh-TW:msg_cert_issue_failed_logs) echo "憑證簽發失敗，請檢查記錄。" ;;
        zh-TW:msg_cert_issue_succeeded) echo "憑證簽發成功，正在安裝憑證..." ;;
        zh-TW:msg_cert_using_existing) echo "使用現有憑證，正在安裝憑證..." ;;
        zh-TW:msg_reloadcmd_default) echo "ACME 的預設 --reloadcmd 為：" ;;
        zh-TW:msg_reloadcmd_runs_on) echo "此命令會在每次簽發與續期憑證時執行。" ;;
        zh-TW:msg_reloadcmd_modify_prompt) echo "是否要修改 ACME 的 --reloadcmd？(y/n)：" ;;
        zh-TW:msg_reloadcmd_preset) echo "預設：systemctl reload nginx ; systemctl restart easyxray" ;;
        zh-TW:msg_reloadcmd_custom) echo "自行輸入命令" ;;
        zh-TW:msg_reloadcmd_keep_default) echo "保留預設 reloadcmd" ;;
        zh-TW:msg_reloadcmd_option_prompt) echo "請選擇一個選項：" ;;
        zh-TW:msg_reloadcmd_is_preset) echo "reloadcmd 為：systemctl reload nginx ; systemctl restart easyxray" ;;
        zh-TW:msg_reloadcmd_order) echo "建議將 easyxray 的重新啟動放在最後" ;;
        zh-TW:msg_reloadcmd_custom_prompt) echo "請輸入自訂的 reloadcmd：" ;;
        zh-TW:msg_reloadcmd_is) printf "reloadcmd 為：%s\n" "$@" ;;
        zh-TW:msg_reloadcmd_keeping) echo "保留預設 reloadcmd" ;;
        zh-TW:msg_cert_installed_autorenew) echo "憑證安裝成功，正在啟用自動續期..." ;;
        zh-TW:msg_cert_install_failed_exit) echo "憑證安裝失敗，即將結束。" ;;
        zh-TW:msg_autorenew_issues) echo "自動續期設定發生問題，憑證詳細資料：" ;;
        zh-TW:msg_autorenew_ok) echo "自動續期成功，憑證詳細資料：" ;;
        zh-TW:msg_cert_set_panel_prompt) echo "是否將此憑證設定為面板的憑證？(y/n)：" ;;
        zh-TW:msg_done_url) echo "存取網址：" ;;
        zh-TW:msg_cert_restart) echo "面板將重新啟動以套用 SSL 憑證..." ;;
        zh-TW:msg_cert_rejected) echo "錯誤：面板拒絕了該憑證，面板將只能以明文 HTTP 提供服務。" ;;
        zh-TW:msg_skip_panel_path) echo "已略過面板憑證路徑設定。" ;;
        zh-TW:msg_ssl_choose) echo "請選擇 SSL 憑證設定方式：" ;;
        zh-TW:msg_ssl_opt1) echo "為網域申請 Let's Encrypt 憑證（90 天效期，自動續期）" ;;
        zh-TW:msg_ssl_opt2) echo "為 IP 位址申請 Let's Encrypt 憑證（6 天效期，自動續期）" ;;
        zh-TW:msg_ssl_opt3) echo "自訂 SSL 憑證（填寫現有檔案路徑）" ;;
        zh-TW:msg_ssl_opt4) echo "略過 SSL（進階：僅限反向代理 / SSH 通道情境）" ;;
        zh-TW:msg_ssl_note_opts) echo "注意：選項 1 與 2 需要開放 80 連接埠。選項 3 需要手動填寫路徑。" ;;
        zh-TW:msg_ssl_note_opt4) echo "注意：選項 4 以明文 HTTP 提供面板服務 - 僅在 nginx/Caddy 或 SSH 通道之後才安全。" ;;
        zh-TW:msg_ssl_mode_unknown) printf "未知的 EASYXRAY_SSL_MODE=%s，將預設使用 none（HTTP）。\n" "$@" ;;
        zh-TW:msg_ssl_pick) echo "請選擇 [預設 2：IP 憑證]：" ;;
        zh-TW:msg_ssl_le_domain) echo "正在使用 Let's Encrypt 簽發域名憑證..." ;;
        zh-TW:msg_ssl_domain_ok) printf "✓ SSL 憑證已設定成功，域名：%s\n" "$@" ;;
        zh-TW:msg_ssl_domain_extract_failed) echo "SSL 設定可能已完成，但域名擷取失敗" ;;
        zh-TW:msg_ssl_domain_failed) echo "域名模式的 SSL 憑證設定失敗。" ;;
        zh-TW:msg_ssl_le_ip) echo "正在使用 Let's Encrypt 簽發 IP 憑證（shortlived 設定檔）..." ;;
        zh-TW:msg_ipv4_confirm_prompt) printf "%s 是此伺服器正確的連入公網 IPv4 位址嗎？[Default y]：\n" "$@" ;;
        zh-TW:msg_ipv4_prompt) echo "請輸入你伺服器的公網 IPv4 位址：" ;;
        zh-TW:msg_ipv4_invalid_retry) echo "IPv4 位址無效。請重試。" ;;
        zh-TW:msg_ipv6_prompt) echo "是否有要包含的 IPv6 位址？（留空則略過）：" ;;
        zh-TW:msg_ipcert_configured) echo "✓ Let's Encrypt IP 憑證設定成功" ;;
        zh-TW:msg_ipcert_setup_failed) echo "✗ IP 憑證設定失敗。請檢查 80 連接埠是否開放。" ;;
        zh-TW:msg_custom_cert_using) echo "正在使用自訂的現有憑證..." ;;
        zh-TW:msg_custom_cert_domain_prompt) echo "請輸入憑證簽發的域名：" ;;
        zh-TW:msg_custom_cert_path_prompt) echo "輸入憑證路徑（關鍵字：.crt / fullchain）：" ;;
        zh-TW:msg_file_missing) echo "錯誤：檔案不存在！請重試。" ;;
        zh-TW:msg_file_unreadable) echo "錯誤：檔案存在但無法讀取（請檢查權限）！" ;;
        zh-TW:msg_file_empty) echo "錯誤：檔案為空！" ;;
        zh-TW:msg_custom_key_path_prompt) echo "輸入私鑰路徑（關鍵字：.key / privatekey）：" ;;
        zh-TW:msg_custom_cert_not_applied) echo "✗ 自訂憑證未生效 -- 面板將以明文 HTTP 提供服務。" ;;
        zh-TW:msg_custom_cert_applied) echo "✓ 自訂憑證路徑已生效。" ;;
        zh-TW:msg_custom_cert_renew_note) echo "注意：你需要自行在外部續期這些檔案。" ;;
        zh-TW:msg_no_ssl_title) echo "⚠ 面板將在未啟用 SSL/TLS 的情況下安裝。" ;;
        zh-TW:msg_no_ssl_plaintext) echo "登入認證資訊與 Cookie 將以明文 HTTP 傳輸。" ;;
        zh-TW:msg_no_ssl_safe_when) echo "僅在下列情況才安全：" ;;
        zh-TW:msg_no_ssl_proxy) echo "  • 由反向代理（nginx、Caddy、Traefik）為你處理 TLS，或" ;;
        zh-TW:msg_no_ssl_tunnel) echo "  • 你僅透過 SSH 通道存取面板" ;;
        zh-TW:msg_bind_localhost_prompt) echo "是否僅將面板綁定到 127.0.0.1？（建議 — 強制透過 SSH 通道 / 反向代理存取）[y/N]：" ;;
        zh-TW:msg_panel_localhost_only) echo "✓ 面板僅綁定 127.0.0.1。現已無法從公網存取。" ;;
        zh-TW:msg_ssh_forward_title) echo "SSH 連接埠轉送 — 可透過以下方式在本機開啟面板：" ;;
        zh-TW:msg_ssh_cmd_standard) echo "  標準 SSH 命令：" ;;
        zh-TW:msg_ssh_cmd_key) echo "  如果使用 SSH 金鑰：" ;;
        zh-TW:msg_ssh_cmd_open) echo "  然後在瀏覽器中開啟：" ;;
        zh-TW:msg_ssh_alt_proxy) printf "替代方案：將反向代理（nginx/Caddy）指向 127.0.0.1:%s，由它處理 TLS。\n" "$@" ;;
        zh-TW:msg_no_ssl_all_interfaces) echo "面板將在所有介面上以明文 HTTP 監聽。請確認在其前端有其他服務處理 TLS。" ;;
        zh-TW:msg_ssl_skipped) echo "✓ 已略過 SSL 設定。" ;;
        zh-TW:msg_ssl_option_invalid) echo "選項無效。略過 SSL 設定。" ;;
        zh-TW:msg_ip_detect_failed) echo "無法從任何服務商自動偵測伺服器 IP。" ;;
        zh-TW:msg_db_selection_title) echo "資料庫選擇" ;;
        zh-TW:msg_db_opt_sqlite) echo "1) SQLite     （預設 — 建議用於少於 500 個用戶端）" ;;
        zh-TW:msg_db_opt_pg) echo "2) PostgreSQL（用戶端數量多 / 節點數量多時建議）" ;;
        zh-TW:msg_choose_default) echo "請選擇 [1]：" ;;
        zh-TW:msg_db_label_pg_external) echo "PostgreSQL（外部）" ;;
        zh-TW:msg_pg_installing_local) echo "正在本機安裝 PostgreSQL（非互動模式）..." ;;
        zh-TW:msg_pg_failed_ni) echo "非互動模式下 PostgreSQL 安裝失敗；正在中止。" ;;
        zh-TW:msg_pg_env_hint) echo "請設定 EASYXRAY_DB_DSN 以使用現有伺服器，或設定 EASYXRAY_DB_TYPE=sqlite。" ;;
        zh-TW:msg_pg_menu_local) echo "1) 在本機安裝 PostgreSQL 並建立專用的使用者與資料庫（建議）" ;;
        zh-TW:msg_pg_menu_external) echo "2) 使用現有的 PostgreSQL 伺服器（輸入 DSN）" ;;
        zh-TW:msg_pg_dsn_prompt) echo "請輸入 PostgreSQL DSN（postgres://user:pass@host:port/dbname?sslmode=disable）：" ;;
        zh-TW:msg_pg_installing) echo "正在安裝 PostgreSQL — 這可能需要一些時間..." ;;
        zh-TW:msg_pg_credfile_failed) echo "建立暫存認證檔案失敗。" ;;
        zh-TW:msg_pg_failed) echo "PostgreSQL 安裝失敗。" ;;
        zh-TW:msg_pg_menu_retry) echo "1) 重試本機安裝" ;;
        zh-TW:msg_pg_menu_dsn) echo "2) 改為輸入外部 DSN" ;;
        zh-TW:msg_pg_menu_abort) echo "3) 中止安裝" ;;
        zh-TW:msg_pg_menu_fallback) echo "4) 退回使用 SQLite" ;;
        zh-TW:msg_install_aborted) echo "安裝已中止。" ;;
        zh-TW:msg_pg_client_missing) echo "⚠ 無法安裝 pg_dump/pg_restore。在安裝 postgresql-client 套件之前，面板內的資料庫備份/還原將無法使用。" ;;
        zh-TW:msg_panel_port) printf "你的面板連接埠為：%s\n" "$@" ;;
        zh-TW:msg_panel_port_random) printf "已產生隨機連接埠：%s\n" "$@" ;;
        zh-TW:msg_panel_port_customize_prompt) echo "是否要自訂面板連接埠設定？（若不自訂，將套用隨機連接埠）[y/n]：" ;;
        zh-TW:msg_panel_port_prompt) echo "請設定面板連接埠：" ;;
        zh-TW:msg_ssl_title) echo "SSL 憑證設定（強烈建議）" ;;
        zh-TW:msg_ssl_recommend) echo "強烈建議啟用 SSL。僅當由反向代理或 SSH 通道負責 TLS 時才略過。" ;;
        zh-TW:msg_ssl_le_note) echo "Let's Encrypt 現已支援網域與 IP 位址！" ;;
        zh-TW:msg_abort1) echo "無法將憑證套用到面板，若繼續將出現「https:// 位址背後實際是明文 HTTP」的情況。" ;;
        zh-TW:msg_abort2) echo "其餘內容未做任何變更；請修好憑證後重新執行安裝腳本。" ;;
        zh-TW:msg_done_title) echo "面板安裝完成！" ;;
        zh-TW:msg_done_user) echo "使用者名稱：" ;;
        zh-TW:msg_done_pass) echo "密碼：" ;;
        zh-TW:msg_done_port) echo "連接埠：" ;;
        zh-TW:msg_done_wbp) echo "面板路徑：" ;;
        zh-TW:msg_done_db) echo "資料庫：" ;;
        zh-TW:msg_done_token) echo "API 權杖：" ;;
        zh-TW:msg_done_save) echo "重要：請妥善保存以上憑證！" ;;
        zh-TW:msg_ssl_on) echo "SSL 憑證：已啟用並設定完成" ;;
        zh-TW:msg_ssl_off) echo "SSL 憑證：已略過 —— 面板僅提供 HTTP，請搭配反向代理或 SSH 通道使用。" ;;
        zh-TW:msg_pg_backup_title) echo "面板內建了 PostgreSQL 備份與還原功能：" ;;
        zh-TW:msg_pg_backup_menu) echo "→ 備份和恢復" ;;
        zh-TW:msg_pg_backup_note) echo "  「備份」會下載 pg_dump 產生的 .dump 檔案；「還原」則透過 pg_restore 重新載入。" ;;
        zh-TW:msg_pg_creds_title) echo "PostgreSQL 認證資訊" ;;
        zh-TW:msg_pg_db_name) echo "資料庫名稱：" ;;
        zh-TW:msg_pg_username) echo "使用者名稱：" ;;
        zh-TW:msg_pg_password) echo "密碼：" ;;
        zh-TW:msg_pg_host) echo "主機：" ;;
        zh-TW:msg_pg_port) echo "連接埠：" ;;
        zh-TW:msg_pg_dsn) echo "DSN：" ;;
        zh-TW:msg_pg_env_file) echo "環境變數檔案：" ;;
        zh-TW:msg_pg_connect) echo "從本伺服器連線：" ;;
        zh-TW:msg_pg_as_superuser) echo "（以 postgres 超級使用者身分）" ;;
        zh-TW:msg_pg_env_read) printf "⚠ 面板從 %s 讀取這些認證資訊。\n" "$@" ;;
        zh-TW:msg_pg_save_password) echo "⚠ 請儲存密碼 — 它不會以明文形式存放在其他任何地方。" ;;
        zh-TW:msg_wbp_generating) echo "WebBasePath 缺失或過短。正在產生新的路徑..." ;;
        zh-TW:msg_wbp_new) printf "新的 WebBasePath：%s\n" "$@" ;;
        zh-TW:msg_default_creds) echo "偵測到預設認證資訊。需要更新安全設定..." ;;
        zh-TW:msg_new_creds) echo "已產生新的隨機登入認證資訊：" ;;
        zh-TW:msg_creds_set) echo "使用者名稱、密碼和 WebBasePath 均已正確設定。" ;;
        zh-TW:msg_ssl_already_configured) echo "SSL 憑證已設定。無需操作。" ;;
        zh-TW:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s，略過 Fail2ban 自動設定。\n" "$@" ;;
        zh-TW:msg_f2b_skipped_cli) echo "找不到 easyxray CLI；略過 Fail2ban 自動設定。" ;;
        zh-TW:msg_f2b_skipped_old) echo "此 easyxray.sh 早於 easyxray setup-fail2ban 子命令；略過 Fail2ban 自動設定。" ;;
        zh-TW:msg_f2b_setup) echo "正在為 IP 限制功能設定 Fail2ban..." ;;
        zh-TW:msg_f2b_done) echo "Fail2ban 設定完成。" ;;
        zh-TW:msg_f2b_incomplete) echo "Fail2ban 設定未完成；在你執行 easyxray 並開啟 IP 限制選單之前，IP 限制將維持停用。繼續執行。" ;;
        zh-TW:msg_systemd_hardening_note) printf "注意：systemd %s 會忽略 easyxray.service 中的部分加固設定；面板仍可啟動。\n" "$@" ;;
        zh-TW:msg_systemd_hardening_missing) printf "      未生效，需要更新的 systemd：%s。\n" "$@" ;;
        zh-TW:msg_systemd_hardening_alias) echo "      面板的目錄透過本腳本安裝的別名 ReadWriteDirectories= 保持可寫。" ;;
        zh-TW:msg_systemd_hardening_rest) echo "      其餘加固設定均已生效。升級 systemd 後可套用上述設定。" ;;
        zh-TW:msg_ws_warn_head) echo "警告：以下目錄包含空白字元，未被寫入" ;;
        zh-TW:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf：%s\n" "$@" ;;
        zh-TW:msg_ws_warn_tail) echo "         面板在單元的沙箱下無法寫入這些目錄。" ;;
        zh-TW:msg_sandbox_refresh_failed) printf "警告：無法重新整理 %s/easyxray.service.d/10-easyxray-sandbox.conf。\n" "$@" ;;
        zh-TW:msg_sandbox_write_hint) echo "如果 EASYXRAY_DB_FOLDER 或 EASYXRAY_LOG_FOLDER 指向 /etc/easyxray 與 /var/log/easyxray 之外，在 ProtectSystem=full 下，面板可能無法寫入。" ;;
        zh-TW:msg_checksum_none) echo "此版本未發佈校驗碼，略過驗證" ;;
        zh-TW:msg_checksum_download_failed) printf "下載 %s 的校驗碼失敗（HTTP %s）\n" "$@" ;;
        zh-TW:msg_checksum_mismatch) printf "%s 的校驗碼不符：預期 %s，實際為 %s\n" "$@" ;;
        zh-TW:msg_checksum_ok) printf "校驗碼驗證通過：%s\n" "$@" ;;
        zh-TW:msg_repo_file_missing) printf "%s 不適用於 %s（HTTP %s）\n" "$@" ;;
        zh-TW:msg_repo_file_missing_hint) echo "請安裝包含該檔案的發行版本，或使用 dev 滾動建置。你現有的安裝未被更動。" ;;
        zh-TW:msg_version_fetch_failed) echo "取得 easyxray 版本失敗，可能是 GitHub API 存取受限，請稍後重試" ;;
        zh-TW:msg_latest_version) printf "已取得 easyxray 最新版本：%s，開始安裝...\n" "$@" ;;
        zh-TW:msg_download_failed) echo "下載 easyxray 失敗，請確認你的伺服器可以存取 GitHub" ;;
        zh-TW:msg_archive_empty) echo "下載的 easyxray 發行封存檔為空" ;;
        zh-TW:msg_dev_build) echo "正在安裝滾動 dev 建置（標籤：dev-latest）。這是依提交發佈的預發行版本，並非穩定版本。" ;;
        zh-TW:msg_install_start) echo "開始安裝" ;;
        zh-TW:msg_download_version_failed) printf "下載 easyxray %s 失敗，請檢查該版本是否存在\n" "$@" ;;
        zh-TW:msg_script_download_failed) echo "下載 easyxray.sh 失敗" ;;
        zh-TW:msg_script_empty) echo "下載的 easyxray.sh 為空" ;;
        zh-TW:msg_bin_backup_failed) echo "無法備份 bin/ -- 其中的自訂檔案在本次更新中不會被保留" ;;
        zh-TW:msg_extract_failed) echo "解壓縮 easyxray 發行封存檔失敗 -- 先前的安裝已被移除，因此在修復前面板無法啟動；請嘗試重新執行安裝程式" ;;
        zh-TW:msg_binary_missing) echo "解壓縮後的 easyxray 封存檔中缺少 easyxray 執行檔 -- 先前的安裝已被移除，因此在修復前面板無法啟動；請嘗試重新執行安裝程式" ;;
        zh-TW:msg_bin_restored) printf "已還原 bin/ 中本版本未包含的自訂檔案：%s\n" "$@" ;;
        zh-TW:msg_script_install_failed) echo "安裝 easyxray.sh 失敗" ;;
        zh-TW:msg_gitignore_added) echo "已將 EasyXray.db 加入 /etc/.gitignore 以供 etckeeper 使用" ;;
        zh-TW:msg_gitignore_created) echo "已建立 /etc/.gitignore 並加入 EasyXray.db 以供 etckeeper 使用" ;;
        zh-TW:msg_rc_download_failed) echo "下載 easyxray.rc 失敗" ;;
        zh-TW:msg_rc_empty) echo "下載的 easyxray.rc 為空" ;;
        zh-TW:msg_rc_install_failed) echo "安裝 easyxray.rc 失敗" ;;
        zh-TW:msg_service_found) echo "在解壓縮檔案中找到 easyxray.service，正在安裝..." ;;
        zh-TW:msg_service_found_variant) printf "在解壓縮檔案中找到 easyxray.service.%s，正在安裝...\n" "$@" ;;
        zh-TW:msg_service_downloading) echo "tar.gz 中找不到服務檔案，正在從 GitHub 下載..." ;;
        zh-TW:msg_service_install_failed) printf "無法從 GitHub 安裝 easyxray.service（%s）-- 發行壓縮檔中也沒有附帶該檔案\n" "$@" ;;
        zh-TW:msg_systemd_setup) echo "正在設定 systemd 單元..." ;;
        zh-TW:msg_service_file_failed) echo "安裝 easyxray.service 檔案失敗" ;;
        zh-TW:msg_installed_ok) echo "安裝完成，面板正在執行..." ;;
        zh-TW:msg_running) echo "執行中..." ;;
        zh-TW:msg_menu_admin) echo "管理腳本" ;;
        zh-TW:msg_menu_start) echo "啟動" ;;
        zh-TW:msg_menu_stop) echo "停止" ;;
        zh-TW:msg_menu_restart) echo "重新啟動" ;;
        zh-TW:msg_menu_status) echo "目前狀態" ;;
        zh-TW:msg_menu_settings) echo "目前設定" ;;
        zh-TW:msg_menu_enable) echo "設定開機自動啟動" ;;
        zh-TW:msg_menu_disable) echo "取消開機自動啟動" ;;
        zh-TW:msg_menu_log) echo "查看記錄" ;;
        zh-TW:msg_menu_banlog) echo "查看 Fail2ban 封鎖記錄" ;;
        zh-TW:msg_menu_update) echo "更新" ;;
        zh-TW:msg_menu_legacy) echo "舊版本" ;;
        zh-TW:msg_menu_install) echo "安裝" ;;
        zh-TW:msg_menu_uninstall) echo "解除安裝" ;;
        # ---- ja-JP ----
        ja-JP:msg_lang_menu_title) echo "インストーラーの言語を選択してください：" ;;
        ja-JP:msg_lang_invalid) echo "無効な選択です。現在の言語のまま続行します。" ;;
        ja-JP:msg_root_required) echo "致命的なエラー：このスクリプトは root 権限で実行してください" ;;
        ja-JP:msg_menu_title) echo "easyxray 制御メニューの使い方（サブコマンド）：" ;;
        ja-JP:msg_unsupported_arch) echo "未対応の CPU アーキテクチャです！" ;;
        ja-JP:msg_arch) printf "アーキテクチャ: %s\n" "$@" ;;
        ja-JP:msg_os_check_failed) echo "システム OS を確認できませんでした。作者に連絡してください！" ;;
        ja-JP:msg_os_release) printf "システムのリリース: %s\n" "$@" ;;
        ja-JP:msg_cert_not_pem) echo "証明書または秘密鍵が読み取り可能な PEM ファイルではありません" ;;
        ja-JP:msg_cert_key_mismatch) echo "秘密鍵が証明書と一致しません" ;;
        ja-JP:msg_cert_file_unreadable) printf "証明書ファイルが見つからないか、空か、読み取れません: %s\n" "$@" ;;
        ja-JP:msg_cert_key_unreadable) printf "秘密鍵ファイルが見つからないか、空か、読み取れません: %s\n" "$@" ;;
        ja-JP:msg_cert_cli_failed) printf "easyxray cert が終了コード %s で失敗しました: %s\n" "$@" ;;
        ja-JP:msg_cert_not_saved) printf "パネルが証明書を保存しませんでした (保存された cert=%s、key=%s)\n" "$@" ;;
        ja-JP:msg_result_write_failed) printf "警告: %s の書き込みに失敗しました。\n" "$@" ;;
        ja-JP:msg_result_written) printf "インストール結果を %s に書き込みました（モード 600）。\n" "$@" ;;
        ja-JP:msg_pg_pgdg_fallback) printf "PostgreSQL %s はこのシステムでは利用できません。代わりにディストリビューション付属の PostgreSQL をインストールします。\n" "$@" ;;
        ja-JP:msg_pg_distro_unsupported) printf "PostgreSQL の自動インストールに対応していないディストリビューション: %s\n" "$@" ;;
        ja-JP:msg_pg_hba_warn) echo "警告: pg_hba.conf を更新できませんでした。PostgreSQL がパネルの TCP ログインを拒否する可能性があります（ident 認証）。" ;;
        ja-JP:msg_pg_cred_write_failed) printf "PostgreSQL の認証情報を %s に書き込めませんでした\n" "$@" ;;
        ja-JP:msg_pg_client_tools) echo "パネル内バックアップ用の PostgreSQL クライアントツール（pg_dump/pg_restore）をインストールしています..." ;;
        ja-JP:msg_acme_installing_ssl) echo "SSL 証明書管理用の acme.sh をインストールしています..." ;;
        ja-JP:msg_acme_failed) echo "acme.sh のインストールに失敗しました" ;;
        ja-JP:msg_acme_ok) echo "acme.sh のインストールに成功しました" ;;
        ja-JP:msg_ssl_setup_start) echo "SSL 証明書をセットアップしています..." ;;
        ja-JP:msg_acme_failed_skip) echo "acme.sh のインストールに失敗したため、SSL の設定をスキップします" ;;
        ja-JP:msg_ssl_issuing_domain) printf "%s の SSL 証明書を発行しています...\n" "$@" ;;
        ja-JP:msg_ssl_port80_note) echo "注意: ポート 80 はインターネットから到達できるよう開放されている必要があります" ;;
        ja-JP:msg_ssl_issue_failed) printf "%s の証明書の発行に失敗しました\n" "$@" ;;
        ja-JP:msg_ssl_retry_hint) echo "ポート 80 が開放されていることを確認し、後ほど easyxray で再試行してください" ;;
        ja-JP:msg_ssl_install_failed) echo "証明書のインストールに失敗しました" ;;
        ja-JP:msg_ssl_installed) echo "SSL 証明書をインストールし、設定が完了しました！" ;;
        ja-JP:msg_cert_files_not_found) echo "証明書ファイルが見つかりません" ;;
        ja-JP:msg_ipcert_setup) echo "Let's Encrypt の IP 証明書（shortlived プロファイル）をセットアップしています..." ;;
        ja-JP:msg_ipcert_validity_note) echo "注意: IP 証明書の有効期間は約 6 日で、自動更新されます。" ;;
        ja-JP:msg_ipcert_port_note) echo "既定のリスナーポートは 80 です。別のポートを選ぶ場合は、外部のポート 80 がそこへ転送されるようにしてください。" ;;
        ja-JP:msg_ipv4_required) echo "IPv4 アドレスが必要です" ;;
        ja-JP:msg_ipv4_invalid) printf "無効な IPv4 アドレス: %s\n" "$@" ;;
        ja-JP:msg_ipv6_included) printf "IPv6 アドレスを含めます: %s\n" "$@" ;;
        ja-JP:msg_acme_port_prompt) echo "ACME HTTP-01 リスナーに使用するポート（既定 80）：" ;;
        ja-JP:msg_port_invalid_fallback) echo "無効なポートが指定されました。80 を使用します。" ;;
        ja-JP:msg_port_using) printf "単独検証にはポート %s を使用します。\n" "$@" ;;
        ja-JP:msg_port_forward_note) printf "注意: Let's Encrypt は引き続きポート 80 に接続します。外部のポート 80 を %s に転送してください。\n" "$@" ;;
        ja-JP:msg_port_in_use) printf "ポート %s は使用中です。\n" "$@" ;;
        ja-JP:msg_port_busy_ni) printf "ポート %s は使用中です。非対話モードでは続行できません。\n" "$@" ;;
        ja-JP:msg_acme_port_retry_prompt) echo "acme.sh の単独リスナー用に別のポートを入力してください（空のままにすると中止）：" ;;
        ja-JP:msg_port_busy) printf "ポート %s は使用中です。続行できません。\n" "$@" ;;
        ja-JP:msg_port_invalid) echo "無効なポートが指定されました。" ;;
        ja-JP:msg_port_free) printf "ポート %s は空いており、単独検証に使用できます。\n" "$@" ;;
        ja-JP:msg_ipcert_issuing) printf "%s の IP 証明書を発行しています...\n" "$@" ;;
        ja-JP:msg_ipcert_issue_failed) echo "IP 証明書の発行に失敗しました" ;;
        ja-JP:msg_ipcert_port_hint) printf "ポート %s に到達できる（または外部のポート 80 から転送されている）ことを確認してください\n" "$@" ;;
        ja-JP:msg_cert_issued_installing) echo "証明書の発行に成功しました。インストールしています..." ;;
        ja-JP:msg_cert_files_missing) echo "インストール後に証明書ファイルが見つかりません" ;;
        ja-JP:msg_cert_files_installed) echo "証明書ファイルをインストールしました" ;;
        ja-JP:msg_cert_paths_setting) echo "パネルの証明書パスを設定しています..." ;;
        ja-JP:msg_cert_files_at) echo "証明書ファイルの場所：" ;;
        ja-JP:msg_cert_file) echo "証明書ファイル：" ;;
        ja-JP:msg_cert_key) echo "秘密鍵ファイル：" ;;
        ja-JP:msg_cert_paths_ok) echo "パネルの証明書パスを設定しました" ;;
        ja-JP:msg_ipcert_installed) echo "IP 証明書をインストールし、設定が完了しました！" ;;
        ja-JP:msg_ipcert_autorenew) echo "証明書の有効期間は約 6 日で、acme.sh の cron ジョブで自動更新されます。" ;;
        ja-JP:msg_acme_autorenew) echo "acme.sh は有効期限前に easyxray を自動更新して再読み込みします。" ;;
        ja-JP:msg_acme_installing) echo "acme.sh をインストールしています..." ;;
        ja-JP:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain には有効な EASYXRAY_DOMAIN が必要です（現在の値: %s）。\n" "$@" ;;
        ja-JP:msg_domain_prompt) echo "ドメイン名を入力してください： " ;;
        ja-JP:msg_domain_empty) echo "ドメイン名を空にすることはできません。もう一度お試しください。" ;;
        ja-JP:msg_domain_invalid) echo "ドメインの形式が正しくありません。有効なドメイン名を入力してください。" ;;
        ja-JP:msg_domain_checking) printf "ドメインは %s です。確認しています...\n" "$@" ;;
        ja-JP:msg_cert_existing_reuse) printf "%s の既存の証明書が見つかりました。それを再利用します。\n" "$@" ;;
        ja-JP:msg_acme_state_incomplete) printf "%s の acme.sh の状態が不完全です（有効な証明書ファイルがありません）。クリーンアップして再発行します。\n" "$@" ;;
        ja-JP:msg_domain_ready) echo "ドメインは証明書を発行できる状態になりました..." ;;
        ja-JP:msg_acme_port_choose_prompt) echo "使用するポートを選択してください（既定は 80）：" ;;
        ja-JP:msg_port_input_invalid) printf "入力された %s は無効です。既定のポート 80 を使用します。\n" "$@" ;;
        ja-JP:msg_port_will_use) printf "証明書の発行にはポート %s を使用します。このポートが開放されていることを確認してください。\n" "$@" ;;
        ja-JP:msg_panel_stopping) echo "パネルを一時的に停止しています..." ;;
        ja-JP:msg_cert_issue_failed_logs) echo "証明書の発行に失敗しました。ログを確認してください。" ;;
        ja-JP:msg_cert_issue_succeeded) echo "証明書の発行に成功しました。証明書をインストールしています..." ;;
        ja-JP:msg_cert_using_existing) echo "既存の証明書を使用します。証明書をインストールしています..." ;;
        ja-JP:msg_reloadcmd_default) echo "ACME の既定の --reloadcmd は次のとおりです：" ;;
        ja-JP:msg_reloadcmd_runs_on) echo "このコマンドは証明書の発行と更新のたびに実行されます。" ;;
        ja-JP:msg_reloadcmd_modify_prompt) echo "ACME の --reloadcmd を変更しますか？(y/n)：" ;;
        ja-JP:msg_reloadcmd_preset) echo "プリセット: systemctl reload nginx ; systemctl restart easyxray" ;;
        ja-JP:msg_reloadcmd_custom) echo "独自のコマンドを入力" ;;
        ja-JP:msg_reloadcmd_keep_default) echo "既定の reloadcmd を維持" ;;
        ja-JP:msg_reloadcmd_option_prompt) echo "オプションを選択してください：" ;;
        ja-JP:msg_reloadcmd_is_preset) echo "reloadcmd は次のとおりです: systemctl reload nginx ; systemctl restart easyxray" ;;
        ja-JP:msg_reloadcmd_order) echo "easyxray の再起動は最後に置くことを推奨します" ;;
        ja-JP:msg_reloadcmd_custom_prompt) echo "独自の reloadcmd を入力してください：" ;;
        ja-JP:msg_reloadcmd_is) printf "reloadcmd は次のとおりです: %s\n" "$@" ;;
        ja-JP:msg_reloadcmd_keeping) echo "既定の reloadcmd を維持します" ;;
        ja-JP:msg_cert_installed_autorenew) echo "証明書のインストールに成功しました。自動更新を有効化しています..." ;;
        ja-JP:msg_cert_install_failed_exit) echo "証明書のインストールに失敗しました。終了します。" ;;
        ja-JP:msg_autorenew_issues) echo "自動更新の設定に問題がありました。証明書の詳細：" ;;
        ja-JP:msg_autorenew_ok) echo "自動更新に成功しました。証明書の詳細：" ;;
        ja-JP:msg_cert_set_panel_prompt) echo "この証明書をパネルに設定しますか？(y/n)：" ;;
        ja-JP:msg_done_url) echo "アクセス URL：" ;;
        ja-JP:msg_cert_restart) echo "SSL 証明書を適用するためパネルを再起動します..." ;;
        ja-JP:msg_cert_rejected) echo "エラー：パネルが証明書を拒否したため、パネルは平文の HTTP で提供される状態でした。" ;;
        ja-JP:msg_skip_panel_path) echo "パネルパスの設定をスキップします。" ;;
        ja-JP:msg_ssl_choose) echo "SSL 証明書の設定方法を選択してください：" ;;
        ja-JP:msg_ssl_opt1) echo "ドメイン用の Let's Encrypt（有効期間 90 日、自動更新）" ;;
        ja-JP:msg_ssl_opt2) echo "IP アドレス用の Let's Encrypt（有効期間 6 日、自動更新）" ;;
        ja-JP:msg_ssl_opt3) echo "独自の SSL 証明書（既存ファイルへのパス）" ;;
        ja-JP:msg_ssl_opt4) echo "SSL をスキップ（上級者向け：リバースプロキシや SSH トンネル専用）" ;;
        ja-JP:msg_ssl_note_opts) echo "注意: オプション 1 と 2 ではポート 80 の開放が必要です。オプション 3 では手動でパスを指定します。" ;;
        ja-JP:msg_ssl_note_opt4) echo "注意: オプション 4 はパネルを平文 HTTP で提供します。nginx/Caddy または SSH トンネルの背後でのみ安全です。" ;;
        ja-JP:msg_ssl_mode_unknown) printf "不明な EASYXRAY_SSL_MODE です（値: %s）。none（HTTP）を既定とします。\n" "$@" ;;
        ja-JP:msg_ssl_pick) echo "オプションを選択してください（IP は既定で 2）： " ;;
        ja-JP:msg_ssl_le_domain) echo "ドメイン証明書に Let's Encrypt を使用します..." ;;
        ja-JP:msg_ssl_domain_ok) printf "✓ SSL 証明書をドメイン %s で正常に設定しました\n" "$@" ;;
        ja-JP:msg_ssl_domain_extract_failed) echo "SSL のセットアップは完了した可能性がありますが、ドメインの抽出に失敗しました" ;;
        ja-JP:msg_ssl_domain_failed) echo "ドメインモードの SSL 証明書セットアップに失敗しました。" ;;
        ja-JP:msg_ssl_le_ip) echo "IP 証明書（shortlived プロファイル）に Let's Encrypt を使用します..." ;;
        ja-JP:msg_ipv4_confirm_prompt) printf "%s はこのサーバーの正しい受信パブリック IPv4 アドレスですか？[Default y]：\n" "$@" ;;
        ja-JP:msg_ipv4_prompt) echo "サーバーのパブリック IPv4 アドレスを入力してください：" ;;
        ja-JP:msg_ipv4_invalid_retry) echo "無効な IPv4 アドレスです。もう一度お試しください。" ;;
        ja-JP:msg_ipv6_prompt) echo "含める IPv6 アドレスはありますか？（空のままにするとスキップ）：" ;;
        ja-JP:msg_ipcert_configured) echo "✓ Let's Encrypt の IP 証明書を正常に設定しました" ;;
        ja-JP:msg_ipcert_setup_failed) echo "✗ IP 証明書のセットアップに失敗しました。ポート 80 が開放されているか確認してください。" ;;
        ja-JP:msg_custom_cert_using) echo "既存のカスタム証明書を使用します..." ;;
        ja-JP:msg_custom_cert_domain_prompt) echo "証明書を発行したドメイン名を入力してください：" ;;
        ja-JP:msg_custom_cert_path_prompt) echo "証明書のパスを入力してください（キーワード: .crt / fullchain）：" ;;
        ja-JP:msg_file_missing) echo "エラー: ファイルが存在しません！もう一度お試しください。" ;;
        ja-JP:msg_file_unreadable) echo "エラー: ファイルは存在しますが読み取れません（権限を確認してください）！" ;;
        ja-JP:msg_file_empty) echo "エラー: ファイルが空です！" ;;
        ja-JP:msg_custom_key_path_prompt) echo "秘密鍵のパスを入力してください（キーワード: .key / privatekey）：" ;;
        ja-JP:msg_custom_cert_not_applied) echo "✗ カスタム証明書は適用されませんでした -- パネルは平文 HTTP で提供される状態です。" ;;
        ja-JP:msg_custom_cert_applied) echo "✓ カスタム証明書のパスを適用しました。" ;;
        ja-JP:msg_custom_cert_renew_note) echo "注意: これらのファイルの更新はご自身で外部から行ってください。" ;;
        ja-JP:msg_no_ssl_title) echo "⚠ パネルは SSL/TLS なしでインストールされます。" ;;
        ja-JP:msg_no_ssl_plaintext) echo "ログイン認証情報と Cookie は平文 HTTP で送信されます。" ;;
        ja-JP:msg_no_ssl_safe_when) echo "次の場合にのみ安全です：" ;;
        ja-JP:msg_no_ssl_proxy) echo "  • リバースプロキシ（nginx、Caddy、Traefik）が TLS を終端してくれる場合、または" ;;
        ja-JP:msg_no_ssl_tunnel) echo "  • パネルに SSH トンネル経由でのみアクセスする場合" ;;
        ja-JP:msg_bind_localhost_prompt) echo "パネルを 127.0.0.1 のみにバインドしますか？（推奨 — SSH トンネル / リバースプロキシ経由のアクセスを強制）[y/N]：" ;;
        ja-JP:msg_panel_localhost_only) echo "✓ パネルを 127.0.0.1 のみにバインドしました。外部インターネットからは到達できません。" ;;
        ja-JP:msg_ssh_forward_title) echo "SSH ポートフォワーディング — ローカルマシンから次の方法でパネルを開けます：" ;;
        ja-JP:msg_ssh_cmd_standard) echo "  標準の SSH コマンド：" ;;
        ja-JP:msg_ssh_cmd_key) echo "  SSH キーを使用する場合：" ;;
        ja-JP:msg_ssh_cmd_open) echo "  その後ブラウザで開きます：" ;;
        ja-JP:msg_ssh_alt_proxy) printf "別の方法: リバースプロキシ（nginx/Caddy）を 127.0.0.1:%s に向け、TLS を終端させます。\n" "$@" ;;
        ja-JP:msg_no_ssl_all_interfaces) echo "パネルはすべてのインターフェースで平文 HTTP をリッスンします。前段で別のものが TLS を終端していることを確認してください。" ;;
        ja-JP:msg_ssl_skipped) echo "✓ SSL のセットアップをスキップしました。" ;;
        ja-JP:msg_ssl_option_invalid) echo "無効なオプションです。SSL のセットアップをスキップします。" ;;
        ja-JP:msg_ip_detect_failed) echo "どのプロバイダーからもサーバー IP を自動検出できませんでした。" ;;
        ja-JP:msg_db_selection_title) echo "データベースの選択" ;;
        ja-JP:msg_db_opt_sqlite) echo "1) SQLite     （既定 — クライアント数 500 未満に推奨）" ;;
        ja-JP:msg_db_opt_pg) echo "2) PostgreSQL （クライアント数が多い場合やノードが多い場合に推奨）" ;;
        ja-JP:msg_choose_default) echo "選択してください [1]：" ;;
        ja-JP:msg_db_label_pg_external) echo "PostgreSQL（外部）" ;;
        ja-JP:msg_pg_installing_local) echo "PostgreSQL をローカルにインストールしています（非対話）..." ;;
        ja-JP:msg_pg_failed_ni) echo "非対話モードでの PostgreSQL インストールに失敗しました。中止します。" ;;
        ja-JP:msg_pg_env_hint) echo "既存のサーバーを使うには EASYXRAY_DB_DSN を設定するか、EASYXRAY_DB_TYPE=sqlite を指定してください。" ;;
        ja-JP:msg_pg_menu_local) echo "1) PostgreSQL をローカルにインストールし、専用のユーザー/DB を作成（推奨）" ;;
        ja-JP:msg_pg_menu_external) echo "2) 既存の PostgreSQL サーバーを使用（DSN を入力）" ;;
        ja-JP:msg_pg_dsn_prompt) echo "PostgreSQL DSN を入力してください（postgres://user:pass@host:port/dbname?sslmode=disable）：" ;;
        ja-JP:msg_pg_installing) echo "PostgreSQL をインストールしています — 少し時間がかかる場合があります..." ;;
        ja-JP:msg_pg_credfile_failed) echo "一時的な認証情報ファイルを作成できませんでした。" ;;
        ja-JP:msg_pg_failed) echo "PostgreSQL のインストールに失敗しました。" ;;
        ja-JP:msg_pg_menu_retry) echo "1) ローカルインストールを再試行" ;;
        ja-JP:msg_pg_menu_dsn) echo "2) 代わりに外部の DSN を入力" ;;
        ja-JP:msg_pg_menu_abort) echo "3) インストールを中止" ;;
        ja-JP:msg_pg_menu_fallback) echo "4) SQLite にフォールバック" ;;
        ja-JP:msg_install_aborted) echo "インストールを中止しました。" ;;
        ja-JP:msg_pg_client_missing) echo "⚠ pg_dump/pg_restore をインストールできませんでした。postgresql-client パッケージをインストールするまで、パネル内のデータベースのバックアップ/復元は利用できません。" ;;
        ja-JP:msg_panel_port) printf "パネルのポート: %s\n" "$@" ;;
        ja-JP:msg_panel_port_random) printf "ランダムなポートを生成しました: %s\n" "$@" ;;
        ja-JP:msg_panel_port_customize_prompt) echo "パネルポートの設定をカスタマイズしますか？（カスタマイズしない場合はランダムなポートが適用されます）[y/n]：" ;;
        ja-JP:msg_panel_port_prompt) echo "パネルのポートを設定してください：" ;;
        ja-JP:msg_ssl_title) echo "SSL 証明書のセットアップ（推奨）" ;;
        ja-JP:msg_ssl_recommend) echo "SSL を強く推奨します。リバースプロキシや SSH トンネルが TLS を処理する場合のみスキップしてください。" ;;
        ja-JP:msg_ssl_le_note) echo "Let's Encrypt はドメインと IP アドレスの両方に対応しました！" ;;
        ja-JP:msg_abort1) echo "証明書をパネルに適用できなかったため、https:// の URL の背後で平文 HTTP が提供される状態でした。" ;;
        ja-JP:msg_abort2) echo "その他の変更はありません。証明書を修正してインストーラーを再実行してください。" ;;
        ja-JP:msg_done_title) echo "パネルのインストールが完了しました！" ;;
        ja-JP:msg_done_user) echo "ユーザー名：" ;;
        ja-JP:msg_done_pass) echo "パスワード：" ;;
        ja-JP:msg_done_port) echo "ポート：" ;;
        ja-JP:msg_done_wbp) echo "WebBasePath（パス）：" ;;
        ja-JP:msg_done_db) echo "データベース：" ;;
        ja-JP:msg_done_token) echo "API トークン：" ;;
        ja-JP:msg_done_save) echo "重要：これらの認証情報は安全に保管してください！" ;;
        ja-JP:msg_ssl_on) echo "SSL 証明書：有効化され設定済みです" ;;
        ja-JP:msg_ssl_off) echo "SSL 証明書：スキップしました。パネルは HTTP のみです。リバースプロキシか SSH トンネルを使用してください。" ;;
        ja-JP:msg_pg_backup_title) echo "PostgreSQL のバックアップと復元はパネルに組み込まれています：" ;;
        ja-JP:msg_pg_backup_menu) echo "→ バックアップと復元" ;;
        ja-JP:msg_pg_backup_note) echo "  バックアップは pg_dump の .dump ファイルをダウンロードし、復元は pg_restore でそれを読み込み直します。" ;;
        ja-JP:msg_pg_creds_title) echo "PostgreSQL の認証情報" ;;
        ja-JP:msg_pg_db_name) echo "データベース名：" ;;
        ja-JP:msg_pg_username) echo "ユーザー名：" ;;
        ja-JP:msg_pg_password) echo "パスワード：" ;;
        ja-JP:msg_pg_host) echo "ホスト：" ;;
        ja-JP:msg_pg_port) echo "ポート：" ;;
        ja-JP:msg_pg_dsn) echo "DSN:" ;;
        ja-JP:msg_pg_env_file) echo "環境変数ファイル：" ;;
        ja-JP:msg_pg_connect) echo "このサーバーから接続：" ;;
        ja-JP:msg_pg_as_superuser) echo "（postgres スーパーユーザーとして）" ;;
        ja-JP:msg_pg_env_read) printf "⚠ パネルはこれらの認証情報を %s から読み取ります。\n" "$@" ;;
        ja-JP:msg_pg_save_password) echo "⚠ パスワードを保存してください — 他の場所に平文で保存されることはありません。" ;;
        ja-JP:msg_wbp_generating) echo "WebBasePath が未設定か短すぎます。新しい値を生成しています..." ;;
        ja-JP:msg_wbp_new) printf "新しい WebBasePath: %s\n" "$@" ;;
        ja-JP:msg_default_creds) echo "既定の認証情報を検出しました。セキュリティ更新が必要です..." ;;
        ja-JP:msg_new_creds) echo "新しいランダムなログイン認証情報を生成しました：" ;;
        ja-JP:msg_creds_set) echo "ユーザー名、パスワード、WebBasePath は正しく設定されています。" ;;
        ja-JP:msg_ssl_already_configured) echo "SSL 証明書はすでに設定済みです。操作は不要です。" ;;
        ja-JP:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s のため、Fail2ban の自動セットアップをスキップします。\n" "$@" ;;
        ja-JP:msg_f2b_skipped_cli) echo "easyxray CLI が見つかりません。Fail2ban の自動セットアップをスキップします。" ;;
        ja-JP:msg_f2b_skipped_old) echo "この easyxray.sh は easyxray setup-fail2ban より前のものです。Fail2ban の自動セットアップをスキップします。" ;;
        ja-JP:msg_f2b_setup) echo "IP 制限機能のために Fail2ban をセットアップしています..." ;;
        ja-JP:msg_f2b_done) echo "Fail2ban のセットアップが完了しました。" ;;
        ja-JP:msg_f2b_incomplete) echo "Fail2ban のセットアップが完了しませんでした。easyxray を実行して IP 制限メニューを開くまで、IP 制限は無効のままです。処理を続行します。" ;;
        ja-JP:msg_systemd_hardening_note) printf "注意: systemd %s は easyxray.service の強化設定の一部を無視しますが、パネルは起動します。\n" "$@" ;;
        ja-JP:msg_systemd_hardening_missing) printf "      適用されません。より新しい systemd が必要です: %s\n" "$@" ;;
        ja-JP:msg_systemd_hardening_alias) echo "      パネルのフォルダーは、このスクリプトがインストールするエイリアス ReadWriteDirectories= を通じて書き込み可能なままです。" ;;
        ja-JP:msg_systemd_hardening_rest) echo "      その他の強化設定は有効です。上記を適用するには systemd をアップグレードしてください。" ;;
        ja-JP:msg_ws_warn_head) echo "警告: 次のフォルダーには空白文字が含まれるため、除外されました" ;;
        ja-JP:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf：%s\n" "$@" ;;
        ja-JP:msg_ws_warn_tail) echo "         パネルはユニットのサンドボックス下ではそこに書き込めません。" ;;
        ja-JP:msg_sandbox_refresh_failed) printf "警告: %s/easyxray.service.d/10-easyxray-sandbox.conf を更新できませんでした。\n" "$@" ;;
        ja-JP:msg_sandbox_write_hint) echo "EASYXRAY_DB_FOLDER または EASYXRAY_LOG_FOLDER が /etc/easyxray と /var/log/easyxray の外を指している場合、ProtectSystem=full の下ではパネルがそこに書き込めない可能性があります。" ;;
        ja-JP:msg_checksum_none) echo "このリリースにはチェックサムが公開されていないため、検証をスキップします" ;;
        ja-JP:msg_checksum_download_failed) printf "%s のチェックサムをダウンロードできませんでした（HTTP %s）\n" "$@" ;;
        ja-JP:msg_checksum_mismatch) printf "%s のチェックサムが一致しません: 期待値 %s、実際の値 %s\n" "$@" ;;
        ja-JP:msg_checksum_ok) printf "チェックサムを検証しました: %s\n" "$@" ;;
        ja-JP:msg_repo_file_missing) printf "%s は %s では利用できません（HTTP %s）\n" "$@" ;;
        ja-JP:msg_repo_file_missing_hint) echo "これを同梱するリリース、またはローリングビルドの dev をインストールしてください。既存のインストールは変更されていません。" ;;
        ja-JP:msg_version_fetch_failed) echo "easyxray のバージョンを取得できませんでした。GitHub API の制限が原因の可能性があります。後でもう一度お試しください" ;;
        ja-JP:msg_latest_version) printf "easyxray の最新バージョン %s を取得しました。インストールを開始します...\n" "$@" ;;
        ja-JP:msg_download_failed) echo "easyxray のダウンロードに失敗しました。サーバーが GitHub にアクセスできるか確認してください" ;;
        ja-JP:msg_archive_empty) echo "ダウンロードした easyxray リリースアーカイブが空です" ;;
        ja-JP:msg_dev_build) echo "ローリング dev ビルド（タグ: dev-latest）をインストールしています。これはコミットごとのプレリリースであり、安定版ではありません。" ;;
        ja-JP:msg_install_start) echo "インストールを開始します：" ;;
        ja-JP:msg_download_version_failed) printf "easyxray %s のダウンロードに失敗しました。そのバージョンが存在するか確認してください\n" "$@" ;;
        ja-JP:msg_script_download_failed) echo "easyxray.sh のダウンロードに失敗しました" ;;
        ja-JP:msg_script_empty) echo "ダウンロードした easyxray.sh が空です" ;;
        ja-JP:msg_bin_backup_failed) echo "bin/ をバックアップできませんでした -- そこにあるカスタムファイルは今回の更新では保持されません" ;;
        ja-JP:msg_extract_failed) echo "easyxray リリースアーカイブの展開に失敗しました -- 以前のインストールはすでに削除されているため、これを修正するまでパネルは起動しません。インストーラーをもう一度実行してみてください" ;;
        ja-JP:msg_binary_missing) echo "展開した easyxray アーカイブに easyxray バイナリがありません -- 以前のインストールはすでに削除されているため、これを修正するまでパネルは起動しません。インストーラーをもう一度実行してみてください" ;;
        ja-JP:msg_bin_restored) printf "このリリースに含まれない bin/ 内のカスタムファイルを復元しました: %s\n" "$@" ;;
        ja-JP:msg_script_install_failed) echo "easyxray.sh のインストールに失敗しました" ;;
        ja-JP:msg_gitignore_added) echo "etckeeper 用に EasyXray.db を /etc/.gitignore に追加しました" ;;
        ja-JP:msg_gitignore_created) echo "/etc/.gitignore を作成し、etckeeper 用に EasyXray.db を追加しました" ;;
        ja-JP:msg_rc_download_failed) echo "easyxray.rc のダウンロードに失敗しました" ;;
        ja-JP:msg_rc_empty) echo "ダウンロードした easyxray.rc が空です" ;;
        ja-JP:msg_rc_install_failed) echo "easyxray.rc のインストールに失敗しました" ;;
        ja-JP:msg_service_found) echo "展開したファイルに easyxray.service が見つかりました。インストールしています..." ;;
        ja-JP:msg_service_found_variant) printf "展開したファイルに easyxray.service.%s が見つかりました。インストールしています...\n" "$@" ;;
        ja-JP:msg_service_downloading) echo "tar.gz にサービスファイルが見つかりません。GitHub からダウンロードしています..." ;;
        ja-JP:msg_service_install_failed) printf "GitHub から easyxray.service をインストールできませんでした（%s）-- リリースの tarball にも同梱されていませんでした\n" "$@" ;;
        ja-JP:msg_systemd_setup) echo "systemd ユニットをセットアップしています..." ;;
        ja-JP:msg_service_file_failed) echo "easyxray.service ファイルのインストールに失敗しました" ;;
        ja-JP:msg_installed_ok) echo "のインストールが完了し、現在実行中です..." ;;
        ja-JP:msg_running) echo "実行中..." ;;
        ja-JP:msg_menu_admin) echo "管理スクリプト" ;;
        ja-JP:msg_menu_start) echo "開始" ;;
        ja-JP:msg_menu_stop) echo "停止" ;;
        ja-JP:msg_menu_restart) echo "再起動" ;;
        ja-JP:msg_menu_status) echo "現在のステータス" ;;
        ja-JP:msg_menu_settings) echo "現在の設定" ;;
        ja-JP:msg_menu_enable) echo "OS 起動時の自動起動を有効化" ;;
        ja-JP:msg_menu_disable) echo "OS 起動時の自動起動を無効化" ;;
        ja-JP:msg_menu_log) echo "ログを確認" ;;
        ja-JP:msg_menu_banlog) echo "Fail2ban の BAN ログを確認" ;;
        ja-JP:msg_menu_update) echo "更新" ;;
        ja-JP:msg_menu_legacy) echo "レガシーバージョン" ;;
        ja-JP:msg_menu_install) echo "インストール" ;;
        ja-JP:msg_menu_uninstall) echo "アンインストール" ;;
        # ---- ru-RU ----
        ru-RU:msg_lang_menu_title) echo "Выберите язык установки:" ;;
        ru-RU:msg_lang_invalid) echo "Неверный выбор, остаётся текущий язык." ;;
        ru-RU:msg_root_required) echo "Критическая ошибка: запустите этот скрипт с правами root" ;;
        ru-RU:msg_menu_title) echo "Использование меню управления easyxray (подкоманды):" ;;
        ru-RU:msg_unsupported_arch) echo "Неподдерживаемая архитектура CPU!" ;;
        ru-RU:msg_arch) printf "Архитектура: %s\n" "$@" ;;
        ru-RU:msg_os_check_failed) echo "Не удалось определить операционную систему, свяжитесь с автором!" ;;
        ru-RU:msg_os_release) printf "Версия операционной системы: %s\n" "$@" ;;
        ru-RU:msg_cert_not_pem) echo "сертификат или закрытый ключ не является читаемым PEM-файлом" ;;
        ru-RU:msg_cert_key_mismatch) echo "закрытый ключ не соответствует сертификату" ;;
        ru-RU:msg_cert_file_unreadable) printf "Файл сертификата отсутствует, пуст или недоступен для чтения: %s\n" "$@" ;;
        ru-RU:msg_cert_key_unreadable) printf "Файл закрытого ключа отсутствует, пуст или недоступен для чтения: %s\n" "$@" ;;
        ru-RU:msg_cert_cli_failed) printf "easyxray cert завершился с кодом %s: %s\n" "$@" ;;
        ru-RU:msg_cert_not_saved) printf "Панель не сохранила сертификат (сохранённый cert=%s, key=%s)\n" "$@" ;;
        ru-RU:msg_result_write_failed) printf "Внимание: не удалось записать %s.\n" "$@" ;;
        ru-RU:msg_result_written) printf "Результат установки записан в %s (режим 600).\n" "$@" ;;
        ru-RU:msg_pg_pgdg_fallback) printf "PostgreSQL %s недоступен для этой системы; вместо него устанавливается PostgreSQL из дистрибутива.\n" "$@" ;;
        ru-RU:msg_pg_distro_unsupported) printf "Дистрибутив не поддерживается для автоматической установки PostgreSQL: %s\n" "$@" ;;
        ru-RU:msg_pg_hba_warn) echo "Внимание: не удалось обновить pg_hba.conf; PostgreSQL может отклонить вход панели по TCP (аутентификация ident)." ;;
        ru-RU:msg_pg_cred_write_failed) printf "Не удалось записать учётные данные PostgreSQL в %s\n" "$@" ;;
        ru-RU:msg_pg_client_tools) echo "Установка клиентских инструментов PostgreSQL (pg_dump/pg_restore) для резервного копирования из панели..." ;;
        ru-RU:msg_acme_installing_ssl) echo "Установка acme.sh для управления SSL-сертификатами..." ;;
        ru-RU:msg_acme_failed) echo "Не удалось установить acme.sh" ;;
        ru-RU:msg_acme_ok) echo "acme.sh успешно установлен" ;;
        ru-RU:msg_ssl_setup_start) echo "Настройка SSL-сертификата..." ;;
        ru-RU:msg_acme_failed_skip) echo "Не удалось установить acme.sh, настройка SSL пропущена" ;;
        ru-RU:msg_ssl_issuing_domain) printf "Выпуск SSL-сертификата для %s...\n" "$@" ;;
        ru-RU:msg_ssl_port80_note) echo "Внимание: порт 80 должен быть открыт и доступен из интернета" ;;
        ru-RU:msg_ssl_issue_failed) printf "Не удалось выпустить сертификат для %s\n" "$@" ;;
        ru-RU:msg_ssl_retry_hint) echo "Убедитесь, что порт 80 открыт, и повторите позже с помощью: easyxray" ;;
        ru-RU:msg_ssl_install_failed) echo "Не удалось установить сертификат" ;;
        ru-RU:msg_ssl_installed) echo "SSL-сертификат успешно установлен и настроен!" ;;
        ru-RU:msg_cert_files_not_found) echo "Файлы сертификата не найдены" ;;
        ru-RU:msg_ipcert_setup) echo "Настройка IP-сертификата Let's Encrypt (профиль shortlived)..." ;;
        ru-RU:msg_ipcert_validity_note) echo "Внимание: IP-сертификаты действительны около 6 дней и продлеваются автоматически." ;;
        ru-RU:msg_ipcert_port_note) echo "По умолчанию используется порт 80. Если вы выберете другой порт, убедитесь, что внешний порт 80 перенаправляется на него." ;;
        ru-RU:msg_ipv4_required) echo "Требуется адрес IPv4" ;;
        ru-RU:msg_ipv4_invalid) printf "Недопустимый адрес IPv4: %s\n" "$@" ;;
        ru-RU:msg_ipv6_included) printf "Включается адрес IPv6: %s\n" "$@" ;;
        ru-RU:msg_acme_port_prompt) echo "Порт для слушателя ACME HTTP-01 (по умолчанию 80):" ;;
        ru-RU:msg_port_invalid_fallback) echo "Указан недопустимый порт. Используется 80." ;;
        ru-RU:msg_port_using) printf "Порт %s используется для отдельной проверки.\n" "$@" ;;
        ru-RU:msg_port_forward_note) printf "Напоминание: Let's Encrypt по-прежнему подключается к порту 80; перенаправьте внешний порт 80 на %s.\n" "$@" ;;
        ru-RU:msg_port_in_use) printf "Порт %s занят.\n" "$@" ;;
        ru-RU:msg_port_busy_ni) printf "Порт %s занят; невозможно продолжить в неинтерактивном режиме.\n" "$@" ;;
        ru-RU:msg_acme_port_retry_prompt) echo "Введите другой порт для автономного слушателя acme.sh (оставьте пустым для отмены):" ;;
        ru-RU:msg_port_busy) printf "Порт %s занят; невозможно продолжить.\n" "$@" ;;
        ru-RU:msg_port_invalid) echo "Указан недопустимый порт." ;;
        ru-RU:msg_port_free) printf "Порт %s свободен и готов для отдельной проверки.\n" "$@" ;;
        ru-RU:msg_ipcert_issuing) printf "Выпуск IP-сертификата для %s...\n" "$@" ;;
        ru-RU:msg_ipcert_issue_failed) echo "Не удалось выпустить IP-сертификат" ;;
        ru-RU:msg_ipcert_port_hint) printf "Убедитесь, что порт %s доступен (или перенаправлен с внешнего порта 80)\n" "$@" ;;
        ru-RU:msg_cert_issued_installing) echo "Сертификат успешно выпущен, установка..." ;;
        ru-RU:msg_cert_files_missing) echo "Файлы сертификата не найдены после установки" ;;
        ru-RU:msg_cert_files_installed) echo "Файлы сертификата успешно установлены" ;;
        ru-RU:msg_cert_paths_setting) echo "Настройка путей к сертификату для панели..." ;;
        ru-RU:msg_cert_files_at) echo "Файлы сертификата находятся в:" ;;
        ru-RU:msg_cert_file) echo "Файл сертификата:" ;;
        ru-RU:msg_cert_key) echo "Файл приватного ключа:" ;;
        ru-RU:msg_cert_paths_ok) echo "Пути к сертификатам заданы для панели" ;;
        ru-RU:msg_ipcert_installed) echo "IP-сертификат успешно установлен и настроен!" ;;
        ru-RU:msg_ipcert_autorenew) echo "Сертификат действителен около 6 дней, автоматически продлевается заданием cron acme.sh." ;;
        ru-RU:msg_acme_autorenew) echo "acme.sh автоматически продлит сертификат и перезагрузит easyxray до истечения срока." ;;
        ru-RU:msg_acme_installing) echo "Установка acme.sh..." ;;
        ru-RU:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain требует корректный EASYXRAY_DOMAIN (получено: '%s').\n" "$@" ;;
        ru-RU:msg_domain_prompt) echo "Введите имя домена: " ;;
        ru-RU:msg_domain_empty) echo "Имя домена не может быть пустым. Попробуйте снова." ;;
        ru-RU:msg_domain_invalid) echo "Неверный формат домена. Введите корректное имя домена." ;;
        ru-RU:msg_domain_checking) printf "Ваш домен: %s, выполняется проверка...\n" "$@" ;;
        ru-RU:msg_cert_existing_reuse) printf "Найден существующий сертификат для %s, он будет использован повторно.\n" "$@" ;;
        ru-RU:msg_acme_state_incomplete) printf "Обнаружено незавершённое состояние acme.sh для %s (нет действительных файлов сертификата); оно будет очищено, и сертификат выпустят заново.\n" "$@" ;;
        ru-RU:msg_domain_ready) echo "Ваш домен готов к выпуску сертификатов..." ;;
        ru-RU:msg_acme_port_choose_prompt) echo "Выберите, какой порт использовать (по умолчанию 80):" ;;
        ru-RU:msg_port_input_invalid) printf "Введённое значение %s недопустимо, будет использован порт 80 по умолчанию.\n" "$@" ;;
        ru-RU:msg_port_will_use) printf "Для выпуска сертификатов будет использован порт: %s. Убедитесь, что он открыт.\n" "$@" ;;
        ru-RU:msg_panel_stopping) echo "Панель временно останавливается..." ;;
        ru-RU:msg_cert_issue_failed_logs) echo "Не удалось выпустить сертификат, проверьте логи." ;;
        ru-RU:msg_cert_issue_succeeded) echo "Сертификат успешно выпущен, установка сертификатов..." ;;
        ru-RU:msg_cert_using_existing) echo "Используется существующий сертификат, установка сертификатов..." ;;
        ru-RU:msg_reloadcmd_default) echo "Значение --reloadcmd по умолчанию для ACME:" ;;
        ru-RU:msg_reloadcmd_runs_on) echo "Эта команда будет выполняться при каждом выпуске и продлении сертификата." ;;
        ru-RU:msg_reloadcmd_modify_prompt) echo "Хотите изменить --reloadcmd для ACME? (y/n):" ;;
        ru-RU:msg_reloadcmd_preset) echo "Предустановленный вариант: systemctl reload nginx ; systemctl restart easyxray" ;;
        ru-RU:msg_reloadcmd_custom) echo "Введите свою команду" ;;
        ru-RU:msg_reloadcmd_keep_default) echo "Оставить reloadcmd по умолчанию" ;;
        ru-RU:msg_reloadcmd_option_prompt) echo "Выберите вариант:" ;;
        ru-RU:msg_reloadcmd_is_preset) echo "Reloadcmd: systemctl reload nginx ; systemctl restart easyxray" ;;
        ru-RU:msg_reloadcmd_order) echo "Рекомендуется ставить перезапуск easyxray в конец" ;;
        ru-RU:msg_reloadcmd_custom_prompt) echo "Введите свою команду reloadcmd:" ;;
        ru-RU:msg_reloadcmd_is) printf "Reloadcmd: %s\n" "$@" ;;
        ru-RU:msg_reloadcmd_keeping) echo "Сохраняется reloadcmd по умолчанию" ;;
        ru-RU:msg_cert_installed_autorenew) echo "Сертификат успешно установлен, включается автообновление..." ;;
        ru-RU:msg_cert_install_failed_exit) echo "Не удалось установить сертификат, выход." ;;
        ru-RU:msg_autorenew_issues) echo "При настройке автообновления возникли проблемы, сведения о сертификате:" ;;
        ru-RU:msg_autorenew_ok) echo "Автообновление выполнено успешно, сведения о сертификате:" ;;
        ru-RU:msg_cert_set_panel_prompt) echo "Назначить этот сертификат для панели? (y/n):" ;;
        ru-RU:msg_done_url) echo "URL доступа:" ;;
        ru-RU:msg_cert_restart) echo "Панель перезапустится, чтобы применить SSL-сертификат..." ;;
        ru-RU:msg_cert_rejected) echo "Ошибка: панель отклонила сертификат, поэтому панель работала бы по простому HTTP." ;;
        ru-RU:msg_skip_panel_path) echo "Настройка пути панели пропущена." ;;
        ru-RU:msg_ssl_choose) echo "Выберите способ настройки SSL-сертификата:" ;;
        ru-RU:msg_ssl_opt1) echo "Let's Encrypt для домена (срок 90 дней, автообновление)" ;;
        ru-RU:msg_ssl_opt2) echo "Let's Encrypt для IP-адреса (срок 6 дней, автообновление)" ;;
        ru-RU:msg_ssl_opt3) echo "Свой SSL-сертификат (путь к существующим файлам)" ;;
        ru-RU:msg_ssl_opt4) echo "Пропустить SSL (для опытных — только за обратным прокси или SSH-туннелем)" ;;
        ru-RU:msg_ssl_note_opts) echo "Внимание: для вариантов 1 и 2 нужен открытый порт 80. Для варианта 3 требуется указать пути вручную." ;;
        ru-RU:msg_ssl_note_opt4) echo "Внимание: вариант 4 отдаёт панель по обычному HTTP - это безопасно только за nginx/Caddy или через SSH-туннель." ;;
        ru-RU:msg_ssl_mode_unknown) printf "Неизвестное значение EASYXRAY_SSL_MODE='%s', используется none (HTTP).\n" "$@" ;;
        ru-RU:msg_ssl_pick) echo "Выберите вариант (по умолчанию 2 для IP): " ;;
        ru-RU:msg_ssl_le_domain) echo "Используется Let's Encrypt для сертификата домена..." ;;
        ru-RU:msg_ssl_domain_ok) printf "✓ SSL-сертификат успешно настроен для домена: %s\n" "$@" ;;
        ru-RU:msg_ssl_domain_extract_failed) echo "Настройка SSL, возможно, завершена, но не удалось извлечь домен" ;;
        ru-RU:msg_ssl_domain_failed) echo "Не удалось настроить SSL-сертификат для режима домена." ;;
        ru-RU:msg_ssl_le_ip) echo "Используется Let's Encrypt для IP-сертификата (профиль shortlived)..." ;;
        ru-RU:msg_ipv4_confirm_prompt) printf "%s — это правильный входящий публичный IPv4-адрес этого сервера? [Default y]:\n" "$@" ;;
        ru-RU:msg_ipv4_prompt) echo "Введите публичный IPv4-адрес вашего сервера:" ;;
        ru-RU:msg_ipv4_invalid_retry) echo "Недопустимый адрес IPv4. Попробуйте ещё раз." ;;
        ru-RU:msg_ipv6_prompt) echo "Есть ли адрес IPv6, который нужно включить? (оставьте пустым для пропуска):" ;;
        ru-RU:msg_ipcert_configured) echo "✓ IP-сертификат Let's Encrypt успешно настроен" ;;
        ru-RU:msg_ipcert_setup_failed) echo "✗ Не удалось настроить IP-сертификат. Проверьте, что порт 80 открыт." ;;
        ru-RU:msg_custom_cert_using) echo "Используется пользовательский существующий сертификат..." ;;
        ru-RU:msg_custom_cert_domain_prompt) echo "Введите доменное имя, для которого выпущен сертификат:" ;;
        ru-RU:msg_custom_cert_path_prompt) echo "Введите путь к сертификату (ключевые слова: .crt / fullchain):" ;;
        ru-RU:msg_file_missing) echo "Ошибка: файл не существует! Попробуйте ещё раз." ;;
        ru-RU:msg_file_unreadable) echo "Ошибка: файл существует, но недоступен для чтения (проверьте права)!" ;;
        ru-RU:msg_file_empty) echo "Ошибка: файл пуст!" ;;
        ru-RU:msg_custom_key_path_prompt) echo "Введите путь к закрытому ключу (ключевые слова: .key / privatekey):" ;;
        ru-RU:msg_custom_cert_not_applied) echo "✗ Пользовательский сертификат не применён -- панель работала бы по обычному HTTP." ;;
        ru-RU:msg_custom_cert_applied) echo "✓ Пути к пользовательскому сертификату применены." ;;
        ru-RU:msg_custom_cert_renew_note) echo "Внимание: вы сами отвечаете за продление этих файлов извне." ;;
        ru-RU:msg_no_ssl_title) echo "⚠ Панель будет установлена БЕЗ SSL/TLS." ;;
        ru-RU:msg_no_ssl_plaintext) echo "Данные для входа и cookie будут передаваться по обычному HTTP." ;;
        ru-RU:msg_no_ssl_safe_when) echo "Безопасно только если:" ;;
        ru-RU:msg_no_ssl_proxy) echo "  • Обратный прокси (nginx, Caddy, Traefik) завершает TLS за вас, или" ;;
        ru-RU:msg_no_ssl_tunnel) echo "  • Вы обращаетесь к панели исключительно через SSH-туннель" ;;
        ru-RU:msg_bind_localhost_prompt) echo "Привязать панель только к 127.0.0.1? (рекомендуется — доступ только через SSH-туннель или обратный прокси) [y/N]:" ;;
        ru-RU:msg_panel_localhost_only) echo "✓ Панель привязана только к 127.0.0.1. Теперь она недоступна из публичного интернета." ;;
        ru-RU:msg_ssh_forward_title) echo "Перенаправление портов SSH — открывайте панель с локальной машины через:" ;;
        ru-RU:msg_ssh_cmd_standard) echo "  Стандартная команда SSH:" ;;
        ru-RU:msg_ssh_cmd_key) echo "  Если используется SSH-ключ:" ;;
        ru-RU:msg_ssh_cmd_open) echo "  Затем откройте в браузере:" ;;
        ru-RU:msg_ssh_alt_proxy) printf "Альтернатива: направьте обратный прокси (nginx/Caddy) на 127.0.0.1:%s и позвольте ему завершать TLS.\n" "$@" ;;
        ru-RU:msg_no_ssl_all_interfaces) echo "Панель будет слушать все интерфейсы по обычному HTTP. Убедитесь, что перед ней TLS завершает что-то другое." ;;
        ru-RU:msg_ssl_skipped) echo "✓ Настройка SSL пропущена." ;;
        ru-RU:msg_ssl_option_invalid) echo "Недопустимый вариант. Настройка SSL пропускается." ;;
        ru-RU:msg_ip_detect_failed) echo "Не удалось автоматически определить IP сервера ни у одного провайдера." ;;
        ru-RU:msg_db_selection_title) echo "Выбор базы данных" ;;
        ru-RU:msg_db_opt_sqlite) echo "1) SQLite     (по умолчанию — рекомендуется для < 500 клиентов)" ;;
        ru-RU:msg_db_opt_pg) echo "2) PostgreSQL (рекомендуется при большом числе клиентов / множестве узлов)" ;;
        ru-RU:msg_choose_default) echo "Выберите [1]:" ;;
        ru-RU:msg_db_label_pg_external) echo "PostgreSQL (внешний)" ;;
        ru-RU:msg_pg_installing_local) echo "Локальная установка PostgreSQL (неинтерактивный режим)..." ;;
        ru-RU:msg_pg_failed_ni) echo "Установка PostgreSQL не удалась в неинтерактивном режиме; установка прервана." ;;
        ru-RU:msg_pg_env_hint) echo "Задайте EASYXRAY_DB_DSN, чтобы использовать существующий сервер, или EASYXRAY_DB_TYPE=sqlite." ;;
        ru-RU:msg_pg_menu_local) echo "1) Установить PostgreSQL локально и создать отдельного пользователя и базу данных (рекомендуется)" ;;
        ru-RU:msg_pg_menu_external) echo "2) Использовать существующий сервер PostgreSQL (введите DSN)" ;;
        ru-RU:msg_pg_dsn_prompt) echo "Введите DSN PostgreSQL (postgres://user:pass@host:port/dbname?sslmode=disable):" ;;
        ru-RU:msg_pg_installing) echo "Установка PostgreSQL — это может занять некоторое время..." ;;
        ru-RU:msg_pg_credfile_failed) echo "Не удалось создать временный файл учётных данных." ;;
        ru-RU:msg_pg_failed) echo "Установка PostgreSQL не удалась." ;;
        ru-RU:msg_pg_menu_retry) echo "1) Повторить локальную установку" ;;
        ru-RU:msg_pg_menu_dsn) echo "2) Ввести внешний DSN" ;;
        ru-RU:msg_pg_menu_abort) echo "3) Прервать установку" ;;
        ru-RU:msg_pg_menu_fallback) echo "4) Перейти на SQLite" ;;
        ru-RU:msg_install_aborted) echo "Установка прервана." ;;
        ru-RU:msg_pg_client_missing) echo "⚠ Не удалось установить pg_dump/pg_restore. Резервное копирование и восстановление базы данных в панели будут недоступны, пока вы не установите пакет postgresql-client." ;;
        ru-RU:msg_panel_port) printf "Порт вашей панели: %s\n" "$@" ;;
        ru-RU:msg_panel_port_random) printf "Сгенерирован случайный порт: %s\n" "$@" ;;
        ru-RU:msg_panel_port_customize_prompt) echo "Настроить порт панели? (Если нет, будет применён случайный порт) [y/n]:" ;;
        ru-RU:msg_panel_port_prompt) echo "Укажите порт панели:" ;;
        ru-RU:msg_ssl_title) echo "Настройка SSL-сертификата (РЕКОМЕНДУЕТСЯ)" ;;
        ru-RU:msg_ssl_recommend) echo "SSL настоятельно рекомендуется. Пропускайте, только если обратный прокси или SSH-туннель обеспечивает TLS." ;;
        ru-RU:msg_ssl_le_note) echo "Let's Encrypt теперь поддерживает и домены, и IP-адреса!" ;;
        ru-RU:msg_abort1) echo "Сертификат не удалось применить к панели, поэтому она работала бы по простому HTTP за URL с https://." ;;
        ru-RU:msg_abort2) echo "Больше ничего не изменено; исправьте сертификат и запустите установщик снова." ;;
        ru-RU:msg_done_title) echo "Установка панели завершена!" ;;
        ru-RU:msg_done_user) echo "Имя пользователя:" ;;
        ru-RU:msg_done_pass) echo "Пароль:" ;;
        ru-RU:msg_done_port) echo "Порт:" ;;
        ru-RU:msg_done_wbp) echo "Путь WebBasePath:" ;;
        ru-RU:msg_done_db) echo "База данных:" ;;
        ru-RU:msg_done_token) echo "API-токен:" ;;
        ru-RU:msg_done_save) echo "ВАЖНО: сохраните эти данные в надёжном месте!" ;;
        ru-RU:msg_ssl_on) echo "SSL-сертификат: включён и настроен" ;;
        ru-RU:msg_ssl_off) echo "SSL-сертификат: пропущен — панель только по HTTP. Используйте обратный прокси или SSH-туннель." ;;
        ru-RU:msg_pg_backup_title) echo "Резервное копирование и восстановление PostgreSQL встроены в панель:" ;;
        ru-RU:msg_pg_backup_menu) echo "→ Бэкап и восстановление" ;;
        ru-RU:msg_pg_backup_note) echo "  «Резервная копия» скачивает файл .dump от pg_dump; «Восстановление» загружает его обратно через pg_restore." ;;
        ru-RU:msg_pg_creds_title) echo "Учётные данные PostgreSQL" ;;
        ru-RU:msg_pg_db_name) echo "Имя базы данных:" ;;
        ru-RU:msg_pg_username) echo "Имя пользователя:" ;;
        ru-RU:msg_pg_password) echo "Пароль:" ;;
        ru-RU:msg_pg_host) echo "Хост:" ;;
        ru-RU:msg_pg_port) echo "Порт:" ;;
        ru-RU:msg_pg_dsn) echo "DSN:" ;;
        ru-RU:msg_pg_env_file) echo "Файл окружения:" ;;
        ru-RU:msg_pg_connect) echo "Подключение с этого сервера:" ;;
        ru-RU:msg_pg_as_superuser) echo "(от имени суперпользователя postgres)" ;;
        ru-RU:msg_pg_env_read) printf "⚠ Панель читает эти учётные данные из %s.\n" "$@" ;;
        ru-RU:msg_pg_save_password) echo "⚠ Сохраните пароль — в другом месте он не хранится в открытом виде." ;;
        ru-RU:msg_wbp_generating) echo "WebBasePath отсутствует или слишком короткий. Создаётся новый..." ;;
        ru-RU:msg_wbp_new) printf "Новый WebBasePath: %s\n" "$@" ;;
        ru-RU:msg_default_creds) echo "Обнаружены учётные данные по умолчанию. Требуется обновление безопасности..." ;;
        ru-RU:msg_new_creds) echo "Сгенерированы новые случайные данные для входа:" ;;
        ru-RU:msg_creds_set) echo "Имя пользователя, пароль и WebBasePath заданы корректно." ;;
        ru-RU:msg_ssl_already_configured) echo "SSL-сертификат уже настроен. Действия не требуются." ;;
        ru-RU:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s, автоматическая настройка Fail2ban пропускается.\n" "$@" ;;
        ru-RU:msg_f2b_skipped_cli) echo "CLI easyxray не найден; автоматическая настройка Fail2ban пропускается." ;;
        ru-RU:msg_f2b_skipped_old) echo "Этот easyxray.sh старше команды 'easyxray setup-fail2ban'; автоматическая настройка Fail2ban пропускается." ;;
        ru-RU:msg_f2b_setup) echo "Настройка Fail2ban для функции ограничения по IP..." ;;
        ru-RU:msg_f2b_done) echo "Настройка Fail2ban завершена." ;;
        ru-RU:msg_f2b_incomplete) echo "Настройка Fail2ban не завершена; ограничение по IP остаётся отключённым, пока вы не запустите 'easyxray' и не откроете меню ограничения по IP. Продолжение." ;;
        ru-RU:msg_systemd_hardening_note) printf "Внимание: systemd %s игнорирует часть настроек защиты в easyxray.service; панель всё равно запустится.\n" "$@" ;;
        ru-RU:msg_systemd_hardening_missing) printf "      Не применено, требуется более новый systemd: %s.\n" "$@" ;;
        ru-RU:msg_systemd_hardening_alias) echo "      Папки панели остаются доступными для записи благодаря ReadWriteDirectories=, псевдониму, который устанавливает этот скрипт." ;;
        ru-RU:msg_systemd_hardening_rest) echo "      Остальные настройки защиты действуют. Обновите systemd, чтобы применить перечисленное выше." ;;
        ru-RU:msg_ws_warn_head) echo "Внимание: эти папки содержат пробелы и были исключены из" ;;
        ru-RU:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf: %s\n" "$@" ;;
        ru-RU:msg_ws_warn_tail) echo "         Панель не может записывать в них под sandbox юнита." ;;
        ru-RU:msg_sandbox_refresh_failed) printf "Внимание: не удалось обновить %s/easyxray.service.d/10-easyxray-sandbox.conf.\n" "$@" ;;
        ru-RU:msg_sandbox_write_hint) echo "Если EASYXRAY_DB_FOLDER или EASYXRAY_LOG_FOLDER указывают за пределы /etc/easyxray и /var/log/easyxray, панель может не иметь возможности записывать туда при ProtectSystem=full." ;;
        ru-RU:msg_checksum_none) echo "Для этого релиза не опубликована контрольная сумма, проверка пропущена" ;;
        ru-RU:msg_checksum_download_failed) printf "Не удалось скачать контрольную сумму для %s (HTTP %s)\n" "$@" ;;
        ru-RU:msg_checksum_mismatch) printf "Несовпадение контрольной суммы для %s: ожидалось %s, получено %s\n" "$@" ;;
        ru-RU:msg_checksum_ok) printf "Контрольная сумма проверена: %s\n" "$@" ;;
        ru-RU:msg_repo_file_missing) printf "%s недоступен для %s (HTTP %s)\n" "$@" ;;
        ru-RU:msg_repo_file_missing_hint) echo "Установите релиз, который его содержит, или 'dev' для скользящей сборки. Ваша текущая установка не затронута." ;;
        ru-RU:msg_version_fetch_failed) echo "Не удалось получить версию easyxray, возможно, из-за ограничений GitHub API, попробуйте позже" ;;
        ru-RU:msg_latest_version) printf "Получена последняя версия easyxray: %s, начинается установка...\n" "$@" ;;
        ru-RU:msg_download_failed) echo "Не удалось скачать easyxray, убедитесь, что ваш сервер имеет доступ к GitHub" ;;
        ru-RU:msg_archive_empty) echo "Скачанный архив релиза easyxray пуст" ;;
        ru-RU:msg_dev_build) echo "Устанавливается скользящая сборка dev (тег: dev-latest). Это предрелиз для каждого коммита, а не стабильная версия." ;;
        ru-RU:msg_install_start) echo "Начало установки" ;;
        ru-RU:msg_download_version_failed) printf "Не удалось скачать easyxray %s, проверьте, существует ли эта версия\n" "$@" ;;
        ru-RU:msg_script_download_failed) echo "Не удалось скачать easyxray.sh" ;;
        ru-RU:msg_script_empty) echo "Скачанный easyxray.sh пуст" ;;
        ru-RU:msg_bin_backup_failed) echo "Не удалось создать резервную копию bin/ -- пользовательские файлы там не сохранятся при этом обновлении" ;;
        ru-RU:msg_extract_failed) echo "Не удалось распаковать архив релиза easyxray -- предыдущая установка уже удалена, поэтому панель не запустится, пока это не будет исправлено; попробуйте запустить установщик ещё раз" ;;
        ru-RU:msg_binary_missing) echo "В распакованном архиве easyxray отсутствует исполняемый файл easyxray -- предыдущая установка уже удалена, поэтому панель не запустится, пока это не будет исправлено; попробуйте запустить установщик ещё раз" ;;
        ru-RU:msg_bin_restored) printf "Восстановлены пользовательские файлы в bin/, не входящие в этот релиз: %s\n" "$@" ;;
        ru-RU:msg_script_install_failed) echo "Не удалось установить easyxray.sh" ;;
        ru-RU:msg_gitignore_added) echo "EasyXray.db добавлен в /etc/.gitignore для etckeeper" ;;
        ru-RU:msg_gitignore_created) echo "Создан /etc/.gitignore и добавлен EasyXray.db для etckeeper" ;;
        ru-RU:msg_rc_download_failed) echo "Не удалось скачать easyxray.rc" ;;
        ru-RU:msg_rc_empty) echo "Скачанный easyxray.rc пуст" ;;
        ru-RU:msg_rc_install_failed) echo "Не удалось установить easyxray.rc" ;;
        ru-RU:msg_service_found) echo "Найден easyxray.service в распакованных файлах, установка..." ;;
        ru-RU:msg_service_found_variant) printf "Найден easyxray.service.%s в распакованных файлах, установка...\n" "$@" ;;
        ru-RU:msg_service_downloading) echo "Файлы службы не найдены в tar.gz, скачивание с GitHub..." ;;
        ru-RU:msg_service_install_failed) printf "Не удалось установить easyxray.service с GitHub (%s) -- архив релиза также его не содержал\n" "$@" ;;
        ru-RU:msg_systemd_setup) echo "Настройка юнита systemd..." ;;
        ru-RU:msg_service_file_failed) echo "Не удалось установить файл easyxray.service" ;;
        ru-RU:msg_installed_ok) echo "установка завершена, панель уже запущена..." ;;
        ru-RU:msg_running) echo "Выполняется..." ;;
        ru-RU:msg_menu_admin) echo "Скрипт администрирования" ;;
        ru-RU:msg_menu_start) echo "Запустить" ;;
        ru-RU:msg_menu_stop) echo "Остановить" ;;
        ru-RU:msg_menu_restart) echo "Перезапустить" ;;
        ru-RU:msg_menu_status) echo "Текущий статус" ;;
        ru-RU:msg_menu_settings) echo "Текущие настройки" ;;
        ru-RU:msg_menu_enable) echo "Включить автозапуск при загрузке системы" ;;
        ru-RU:msg_menu_disable) echo "Отключить автозапуск при загрузке системы" ;;
        ru-RU:msg_menu_log) echo "Просмотреть логи" ;;
        ru-RU:msg_menu_banlog) echo "Просмотреть логи блокировок Fail2ban" ;;
        ru-RU:msg_menu_update) echo "Обновить" ;;
        ru-RU:msg_menu_legacy) echo "Устаревшая версия" ;;
        ru-RU:msg_menu_install) echo "Установить" ;;
        ru-RU:msg_menu_uninstall) echo "Удалить" ;;
        # ---- vi-VN ----
        vi-VN:msg_lang_menu_title) echo "Chọn ngôn ngữ cài đặt:" ;;
        vi-VN:msg_lang_invalid) echo "Lựa chọn không hợp lệ, giữ nguyên ngôn ngữ hiện tại." ;;
        vi-VN:msg_root_required) echo "Lỗi nghiêm trọng: Hãy chạy script này với quyền root" ;;
        vi-VN:msg_menu_title) echo "Cách dùng menu điều khiển easyxray (các lệnh con):" ;;
        vi-VN:msg_unsupported_arch) echo "Kiến trúc CPU không được hỗ trợ!" ;;
        vi-VN:msg_arch) printf "Kiến trúc: %s\n" "$@" ;;
        vi-VN:msg_os_check_failed) echo "Không kiểm tra được hệ điều hành của hệ thống, vui lòng liên hệ tác giả!" ;;
        vi-VN:msg_os_release) printf "Bản phát hành hệ điều hành: %s\n" "$@" ;;
        vi-VN:msg_cert_not_pem) echo "Chứng chỉ hoặc khóa riêng không phải là tệp PEM đọc được" ;;
        vi-VN:msg_cert_key_mismatch) echo "Khóa riêng không khớp với chứng chỉ" ;;
        vi-VN:msg_cert_file_unreadable) printf "Tệp chứng chỉ bị thiếu, rỗng hoặc không đọc được: %s\n" "$@" ;;
        vi-VN:msg_cert_key_unreadable) printf "Tệp khóa riêng bị thiếu, rỗng hoặc không đọc được: %s\n" "$@" ;;
        vi-VN:msg_cert_cli_failed) printf "easyxray cert thoát với mã %s: %s\n" "$@" ;;
        vi-VN:msg_cert_not_saved) printf "Bảng điều khiển không lưu chứng chỉ (cert đã lưu=%s, key=%s)\n" "$@" ;;
        vi-VN:msg_result_write_failed) printf "Cảnh báo: không ghi được %s.\n" "$@" ;;
        vi-VN:msg_result_written) printf "Kết quả cài đặt đã được ghi vào %s (chế độ 600).\n" "$@" ;;
        vi-VN:msg_pg_pgdg_fallback) printf "PostgreSQL %s không khả dụng cho hệ thống này; thay vào đó sẽ cài PostgreSQL của bản phân phối.\n" "$@" ;;
        vi-VN:msg_pg_distro_unsupported) printf "Bản phân phối không được hỗ trợ để tự động cài PostgreSQL: %s\n" "$@" ;;
        vi-VN:msg_pg_hba_warn) echo "Cảnh báo: không cập nhật được pg_hba.conf; PostgreSQL có thể từ chối đăng nhập TCP của panel (xác thực ident)." ;;
        vi-VN:msg_pg_cred_write_failed) printf "Không ghi được thông tin đăng nhập PostgreSQL vào %s\n" "$@" ;;
        vi-VN:msg_pg_client_tools) echo "Đang cài công cụ máy khách PostgreSQL (pg_dump/pg_restore) để sao lưu trong panel..." ;;
        vi-VN:msg_acme_installing_ssl) echo "Đang cài acme.sh để quản lý chứng chỉ SSL..." ;;
        vi-VN:msg_acme_failed) echo "Cài đặt acme.sh thất bại" ;;
        vi-VN:msg_acme_ok) echo "acme.sh đã cài đặt thành công" ;;
        vi-VN:msg_ssl_setup_start) echo "Đang thiết lập chứng chỉ SSL..." ;;
        vi-VN:msg_acme_failed_skip) echo "Cài đặt acme.sh thất bại, bỏ qua thiết lập SSL" ;;
        vi-VN:msg_ssl_issuing_domain) printf "Đang cấp chứng chỉ SSL cho %s...\n" "$@" ;;
        vi-VN:msg_ssl_port80_note) echo "Lưu ý: Cổng 80 phải được mở và truy cập được từ internet" ;;
        vi-VN:msg_ssl_issue_failed) printf "Cấp chứng chỉ cho %s thất bại\n" "$@" ;;
        vi-VN:msg_ssl_retry_hint) echo "Hãy đảm bảo cổng 80 đã mở và thử lại sau bằng easyxray" ;;
        vi-VN:msg_ssl_install_failed) echo "Cài đặt chứng chỉ thất bại" ;;
        vi-VN:msg_ssl_installed) echo "Đã cài đặt và cấu hình chứng chỉ SSL thành công!" ;;
        vi-VN:msg_cert_files_not_found) echo "Không tìm thấy tệp chứng chỉ" ;;
        vi-VN:msg_ipcert_setup) echo "Đang thiết lập chứng chỉ IP của Let's Encrypt (hồ sơ shortlived)..." ;;
        vi-VN:msg_ipcert_validity_note) echo "Lưu ý: Chứng chỉ IP có hiệu lực khoảng 6 ngày và sẽ tự gia hạn." ;;
        vi-VN:msg_ipcert_port_note) echo "Cổng lắng nghe mặc định là 80. Nếu bạn chọn cổng khác, hãy đảm bảo cổng 80 bên ngoài được chuyển tiếp tới cổng đó." ;;
        vi-VN:msg_ipv4_required) echo "Cần có địa chỉ IPv4" ;;
        vi-VN:msg_ipv4_invalid) printf "Địa chỉ IPv4 không hợp lệ: %s\n" "$@" ;;
        vi-VN:msg_ipv6_included) printf "Bao gồm địa chỉ IPv6: %s\n" "$@" ;;
        vi-VN:msg_acme_port_prompt) echo "Cổng dùng cho trình lắng nghe ACME HTTP-01 (mặc định 80):" ;;
        vi-VN:msg_port_invalid_fallback) echo "Cổng nhập vào không hợp lệ. Sẽ dùng cổng 80." ;;
        vi-VN:msg_port_using) printf "Dùng cổng %s để xác thực độc lập.\n" "$@" ;;
        vi-VN:msg_port_forward_note) printf "Nhắc nhở: Let's Encrypt vẫn kết nối qua cổng 80; hãy chuyển tiếp cổng 80 bên ngoài tới %s.\n" "$@" ;;
        vi-VN:msg_port_in_use) printf "Cổng %s đang được sử dụng.\n" "$@" ;;
        vi-VN:msg_port_busy_ni) printf "Cổng %s đang bận; không thể tiếp tục ở chế độ không tương tác.\n" "$@" ;;
        vi-VN:msg_acme_port_retry_prompt) echo "Nhập cổng khác cho trình lắng nghe độc lập của acme.sh (để trống để hủy):" ;;
        vi-VN:msg_port_busy) printf "Cổng %s đang bận; không thể tiếp tục.\n" "$@" ;;
        vi-VN:msg_port_invalid) echo "Cổng nhập vào không hợp lệ." ;;
        vi-VN:msg_port_free) printf "Cổng %s đang trống và sẵn sàng cho xác thực độc lập.\n" "$@" ;;
        vi-VN:msg_ipcert_issuing) printf "Đang cấp chứng chỉ IP cho %s...\n" "$@" ;;
        vi-VN:msg_ipcert_issue_failed) echo "Cấp chứng chỉ IP thất bại" ;;
        vi-VN:msg_ipcert_port_hint) printf "Hãy đảm bảo cổng %s có thể truy cập được (hoặc được chuyển tiếp từ cổng 80 bên ngoài)\n" "$@" ;;
        vi-VN:msg_cert_issued_installing) echo "Cấp chứng chỉ thành công, đang cài đặt..." ;;
        vi-VN:msg_cert_files_missing) echo "Không tìm thấy tệp chứng chỉ sau khi cài đặt" ;;
        vi-VN:msg_cert_files_installed) echo "Đã cài đặt tệp chứng chỉ thành công" ;;
        vi-VN:msg_cert_paths_setting) echo "Đang đặt đường dẫn chứng chỉ cho panel..." ;;
        vi-VN:msg_cert_files_at) echo "Tệp chứng chỉ nằm tại:" ;;
        vi-VN:msg_cert_file) echo "Tệp chứng chỉ:" ;;
        vi-VN:msg_cert_key) echo "Tệp khóa riêng:" ;;
        vi-VN:msg_cert_paths_ok) echo "Đã đặt đường dẫn chứng chỉ cho panel" ;;
        vi-VN:msg_ipcert_installed) echo "Đã cài đặt và cấu hình chứng chỉ IP thành công!" ;;
        vi-VN:msg_ipcert_autorenew) echo "Chứng chỉ có hiệu lực khoảng 6 ngày, tự gia hạn qua cron job của acme.sh." ;;
        vi-VN:msg_acme_autorenew) echo "acme.sh sẽ tự gia hạn và tải lại easyxray trước khi hết hạn." ;;
        vi-VN:msg_acme_installing) echo "Đang cài đặt acme.sh..." ;;
        vi-VN:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain yêu cầu EASYXRAY_DOMAIN hợp lệ (nhận được: %s).\n" "$@" ;;
        vi-VN:msg_domain_prompt) echo "Vui lòng nhập tên miền của bạn: " ;;
        vi-VN:msg_domain_empty) echo "Tên miền không được để trống. Vui lòng thử lại." ;;
        vi-VN:msg_domain_invalid) echo "Định dạng tên miền không hợp lệ. Hãy nhập tên miền hợp lệ." ;;
        vi-VN:msg_domain_checking) printf "Tên miền của bạn là: %s, đang kiểm tra...\n" "$@" ;;
        vi-VN:msg_cert_existing_reuse) printf "Đã tìm thấy chứng chỉ hiện có cho %s, sẽ dùng lại.\n" "$@" ;;
        vi-VN:msg_acme_state_incomplete) printf "Phát hiện trạng thái acme.sh chưa hoàn chỉnh cho %s (không có tệp chứng chỉ hợp lệ); sẽ dọn dẹp và cấp lại.\n" "$@" ;;
        vi-VN:msg_domain_ready) echo "Tên miền của bạn đã sẵn sàng để cấp chứng chỉ..." ;;
        vi-VN:msg_acme_port_choose_prompt) echo "Vui lòng chọn cổng để sử dụng (mặc định là 80):" ;;
        vi-VN:msg_port_input_invalid) printf "Giá trị bạn nhập %s không hợp lệ, sẽ dùng cổng mặc định 80.\n" "$@" ;;
        vi-VN:msg_port_will_use) printf "Sẽ dùng cổng %s để cấp chứng chỉ. Hãy đảm bảo cổng này đã được mở.\n" "$@" ;;
        vi-VN:msg_panel_stopping) echo "Tạm dừng panel..." ;;
        vi-VN:msg_cert_issue_failed_logs) echo "Cấp chứng chỉ thất bại, vui lòng kiểm tra nhật ký." ;;
        vi-VN:msg_cert_issue_succeeded) echo "Cấp chứng chỉ thành công, đang cài đặt chứng chỉ..." ;;
        vi-VN:msg_cert_using_existing) echo "Dùng chứng chỉ hiện có, đang cài đặt chứng chỉ..." ;;
        vi-VN:msg_reloadcmd_default) echo "--reloadcmd mặc định cho ACME là:" ;;
        vi-VN:msg_reloadcmd_runs_on) echo "Lệnh này sẽ chạy mỗi lần cấp và gia hạn chứng chỉ." ;;
        vi-VN:msg_reloadcmd_modify_prompt) echo "Bạn có muốn sửa --reloadcmd cho ACME không? (y/n):" ;;
        vi-VN:msg_reloadcmd_preset) echo "Cài sẵn: systemctl reload nginx ; systemctl restart easyxray" ;;
        vi-VN:msg_reloadcmd_custom) echo "Nhập lệnh của riêng bạn" ;;
        vi-VN:msg_reloadcmd_keep_default) echo "Giữ reloadcmd mặc định" ;;
        vi-VN:msg_reloadcmd_option_prompt) echo "Chọn một tùy chọn:" ;;
        vi-VN:msg_reloadcmd_is_preset) echo "Reloadcmd là: systemctl reload nginx ; systemctl restart easyxray" ;;
        vi-VN:msg_reloadcmd_order) echo "Nên đặt lệnh khởi động lại easyxray ở cuối" ;;
        vi-VN:msg_reloadcmd_custom_prompt) echo "Vui lòng nhập reloadcmd tùy chỉnh của bạn:" ;;
        vi-VN:msg_reloadcmd_is) printf "Reloadcmd là: %s\n" "$@" ;;
        vi-VN:msg_reloadcmd_keeping) echo "Đang giữ reloadcmd mặc định" ;;
        vi-VN:msg_cert_installed_autorenew) echo "Cài đặt chứng chỉ thành công, đang bật tự gia hạn..." ;;
        vi-VN:msg_cert_install_failed_exit) echo "Cài đặt chứng chỉ thất bại, đang thoát." ;;
        vi-VN:msg_autorenew_issues) echo "Thiết lập tự gia hạn gặp vấn đề, chi tiết chứng chỉ:" ;;
        vi-VN:msg_autorenew_ok) echo "Tự gia hạn thành công, chi tiết chứng chỉ:" ;;
        vi-VN:msg_cert_set_panel_prompt) echo "Bạn có muốn đặt chứng chỉ này cho panel không? (y/n):" ;;
        vi-VN:msg_done_url) echo "URL truy cập:" ;;
        vi-VN:msg_cert_restart) echo "Panel sẽ khởi động lại để áp dụng chứng chỉ SSL..." ;;
        vi-VN:msg_cert_rejected) echo "Lỗi: panel từ chối chứng chỉ, nên panel sẽ chạy HTTP thường." ;;
        vi-VN:msg_skip_panel_path) echo "Bỏ qua thiết lập đường dẫn panel." ;;
        vi-VN:msg_ssl_choose) echo "Chọn phương thức thiết lập chứng chỉ SSL:" ;;
        vi-VN:msg_ssl_opt1) echo "Let's Encrypt cho Tên miền (hiệu lực 90 ngày, tự gia hạn)" ;;
        vi-VN:msg_ssl_opt2) echo "Let's Encrypt cho Địa chỉ IP (hiệu lực 6 ngày, tự gia hạn)" ;;
        vi-VN:msg_ssl_opt3) echo "Chứng chỉ SSL tùy chỉnh (Đường dẫn tới tệp có sẵn)" ;;
        vi-VN:msg_ssl_opt4) echo "Bỏ qua SSL (nâng cao - chỉ khi sau reverse proxy / SSH tunnel)" ;;
        vi-VN:msg_ssl_note_opts) echo "Lưu ý: Tùy chọn 1 và 2 cần mở cổng 80. Tùy chọn 3 cần nhập đường dẫn thủ công." ;;
        vi-VN:msg_ssl_note_opt4) echo "Lưu ý: Tùy chọn 4 phục vụ panel qua HTTP thường - chỉ an toàn khi nằm sau nginx/Caddy hoặc SSH tunnel." ;;
        vi-VN:msg_ssl_mode_unknown) printf "EASYXRAY_SSL_MODE không xác định (giá trị: %s), mặc định dùng none (HTTP).\n" "$@" ;;
        vi-VN:msg_ssl_pick) echo "Chọn một tùy chọn (mặc định 2 cho IP): " ;;
        vi-VN:msg_ssl_le_domain) echo "Dùng Let's Encrypt cho chứng chỉ tên miền..." ;;
        vi-VN:msg_ssl_domain_ok) printf "✓ Đã cấu hình chứng chỉ SSL thành công với tên miền %s\n" "$@" ;;
        vi-VN:msg_ssl_domain_extract_failed) echo "Thiết lập SSL có thể đã xong, nhưng việc trích xuất tên miền thất bại" ;;
        vi-VN:msg_ssl_domain_failed) echo "Thiết lập chứng chỉ SSL cho chế độ tên miền thất bại." ;;
        vi-VN:msg_ssl_le_ip) echo "Dùng Let's Encrypt cho chứng chỉ IP (hồ sơ shortlived)..." ;;
        vi-VN:msg_ipv4_confirm_prompt) printf "%s có phải là địa chỉ IPv4 công cộng đúng mà máy chủ này nhận được không? [Default y]:\n" "$@" ;;
        vi-VN:msg_ipv4_prompt) echo "Vui lòng nhập địa chỉ IPv4 công cộng của máy chủ:" ;;
        vi-VN:msg_ipv4_invalid_retry) echo "Địa chỉ IPv4 không hợp lệ. Vui lòng thử lại." ;;
        vi-VN:msg_ipv6_prompt) echo "Bạn có địa chỉ IPv6 cần bao gồm không? (để trống để bỏ qua):" ;;
        vi-VN:msg_ipcert_configured) echo "✓ Đã cấu hình chứng chỉ IP Let's Encrypt thành công" ;;
        vi-VN:msg_ipcert_setup_failed) echo "✗ Thiết lập chứng chỉ IP thất bại. Vui lòng kiểm tra cổng 80 đã mở." ;;
        vi-VN:msg_custom_cert_using) echo "Đang dùng chứng chỉ tùy chỉnh có sẵn..." ;;
        vi-VN:msg_custom_cert_domain_prompt) echo "Vui lòng nhập tên miền mà chứng chỉ được cấp cho:" ;;
        vi-VN:msg_custom_cert_path_prompt) echo "Nhập đường dẫn chứng chỉ (từ khóa: .crt / fullchain):" ;;
        vi-VN:msg_file_missing) echo "Lỗi: Tệp không tồn tại! Vui lòng thử lại." ;;
        vi-VN:msg_file_unreadable) echo "Lỗi: Tệp tồn tại nhưng không đọc được (hãy kiểm tra quyền)!" ;;
        vi-VN:msg_file_empty) echo "Lỗi: Tệp trống!" ;;
        vi-VN:msg_custom_key_path_prompt) echo "Nhập đường dẫn khóa riêng (từ khóa: .key / privatekey):" ;;
        vi-VN:msg_custom_cert_not_applied) echo "✗ Chứng chỉ tùy chỉnh chưa được áp dụng -- panel sẽ chạy HTTP thường." ;;
        vi-VN:msg_custom_cert_applied) echo "✓ Đã áp dụng đường dẫn chứng chỉ tùy chỉnh." ;;
        vi-VN:msg_custom_cert_renew_note) echo "Lưu ý: Bạn phải tự gia hạn các tệp này từ bên ngoài." ;;
        vi-VN:msg_no_ssl_title) echo "⚠ Panel sẽ được cài đặt KHÔNG có SSL/TLS." ;;
        vi-VN:msg_no_ssl_plaintext) echo "Thông tin đăng nhập và cookie sẽ truyền qua HTTP thường." ;;
        vi-VN:msg_no_ssl_safe_when) echo "Chỉ an toàn khi:" ;;
        vi-VN:msg_no_ssl_proxy) echo "  • Có reverse proxy (nginx, Caddy, Traefik) xử lý TLS thay bạn, hoặc" ;;
        vi-VN:msg_no_ssl_tunnel) echo "  • Bạn chỉ truy cập panel qua SSH tunnel" ;;
        vi-VN:msg_bind_localhost_prompt) echo "Chỉ bind panel vào 127.0.0.1? (khuyến nghị — buộc truy cập qua SSH tunnel / reverse proxy) [y/N]:" ;;
        vi-VN:msg_panel_localhost_only) echo "✓ Panel chỉ lắng nghe trên 127.0.0.1. Hiện không thể truy cập từ internet công cộng." ;;
        vi-VN:msg_ssh_forward_title) echo "Chuyển tiếp cổng SSH — mở panel từ máy cục bộ của bạn qua:" ;;
        vi-VN:msg_ssh_cmd_standard) echo "  Lệnh SSH tiêu chuẩn:" ;;
        vi-VN:msg_ssh_cmd_key) echo "  Nếu dùng khóa SSH:" ;;
        vi-VN:msg_ssh_cmd_open) echo "  Sau đó mở trong trình duyệt:" ;;
        vi-VN:msg_ssh_alt_proxy) printf "Cách khác: trỏ reverse proxy (nginx/Caddy) tới 127.0.0.1:%s và để nó xử lý TLS.\n" "$@" ;;
        vi-VN:msg_no_ssl_all_interfaces) echo "Panel sẽ lắng nghe trên mọi giao diện qua HTTP thường. Hãy đảm bảo có thứ khác xử lý TLS phía trước nó." ;;
        vi-VN:msg_ssl_skipped) echo "✓ Đã bỏ qua thiết lập SSL." ;;
        vi-VN:msg_ssl_option_invalid) echo "Tùy chọn không hợp lệ. Bỏ qua thiết lập SSL." ;;
        vi-VN:msg_ip_detect_failed) echo "Không thể tự động phát hiện IP máy chủ từ bất kỳ nhà cung cấp nào." ;;
        vi-VN:msg_db_selection_title) echo "Chọn cơ sở dữ liệu" ;;
        vi-VN:msg_db_opt_sqlite) echo "1) SQLite     (mặc định — khuyến nghị cho dưới 500 client)" ;;
        vi-VN:msg_db_opt_pg) echo "2) PostgreSQL (khuyến nghị khi có nhiều client / nhiều node)" ;;
        vi-VN:msg_choose_default) echo "Chọn [1]:" ;;
        vi-VN:msg_db_label_pg_external) echo "PostgreSQL (bên ngoài)" ;;
        vi-VN:msg_pg_installing_local) echo "Đang cài PostgreSQL cục bộ (không tương tác)..." ;;
        vi-VN:msg_pg_failed_ni) echo "Cài đặt PostgreSQL thất bại ở chế độ không tương tác; đang hủy." ;;
        vi-VN:msg_pg_env_hint) echo "Đặt EASYXRAY_DB_DSN để dùng máy chủ có sẵn, hoặc EASYXRAY_DB_TYPE=sqlite." ;;
        vi-VN:msg_pg_menu_local) echo "1) Cài PostgreSQL cục bộ và tạo người dùng/cơ sở dữ liệu riêng (khuyến nghị)" ;;
        vi-VN:msg_pg_menu_external) echo "2) Dùng máy chủ PostgreSQL có sẵn (nhập DSN)" ;;
        vi-VN:msg_pg_dsn_prompt) echo "Nhập DSN PostgreSQL (postgres://user:pass@host:port/dbname?sslmode=disable):" ;;
        vi-VN:msg_pg_installing) echo "Đang cài PostgreSQL — quá trình này có thể mất một lúc..." ;;
        vi-VN:msg_pg_credfile_failed) echo "Không tạo được tệp thông tin đăng nhập tạm thời." ;;
        vi-VN:msg_pg_failed) echo "Cài đặt PostgreSQL thất bại." ;;
        vi-VN:msg_pg_menu_retry) echo "1) Thử lại cài đặt cục bộ" ;;
        vi-VN:msg_pg_menu_dsn) echo "2) Thay vào đó nhập DSN bên ngoài" ;;
        vi-VN:msg_pg_menu_abort) echo "3) Hủy cài đặt" ;;
        vi-VN:msg_pg_menu_fallback) echo "4) Chuyển sang dùng SQLite" ;;
        vi-VN:msg_install_aborted) echo "Đã hủy cài đặt." ;;
        vi-VN:msg_pg_client_missing) echo "⚠ Không cài được pg_dump/pg_restore. Tính năng sao lưu/khôi phục cơ sở dữ liệu trong panel sẽ không khả dụng cho tới khi bạn cài gói postgresql-client." ;;
        vi-VN:msg_panel_port) printf "Cổng panel của bạn là: %s\n" "$@" ;;
        vi-VN:msg_panel_port_random) printf "Đã tạo cổng ngẫu nhiên: %s\n" "$@" ;;
        vi-VN:msg_panel_port_customize_prompt) echo "Bạn có muốn tùy chỉnh cài đặt Cổng Panel không? (Nếu không, một cổng ngẫu nhiên sẽ được áp dụng) [y/n]:" ;;
        vi-VN:msg_panel_port_prompt) echo "Vui lòng thiết lập cổng panel:" ;;
        vi-VN:msg_ssl_title) echo "Thiết lập Chứng chỉ số SSL (KHUYẾN NGHỊ)" ;;
        vi-VN:msg_ssl_recommend) echo "Rất nên dùng SSL. Chỉ bỏ qua nếu reverse proxy hoặc SSH tunnel đã xử lý TLS cho bạn." ;;
        vi-VN:msg_ssl_le_note) echo "Let's Encrypt nay đã hỗ trợ cả tên miền và địa chỉ IP!" ;;
        vi-VN:msg_abort1) echo "Không thể áp dụng chứng chỉ cho panel, nên panel chạy HTTP thường sau URL https://." ;;
        vi-VN:msg_abort2) echo "Không có gì khác bị thay đổi; hãy sửa chứng chỉ rồi chạy lại trình cài đặt." ;;
        vi-VN:msg_done_title) echo "Cài đặt Panel Hoàn tất!" ;;
        vi-VN:msg_done_user) echo "Tên người dùng:" ;;
        vi-VN:msg_done_pass) echo "Mật khẩu:" ;;
        vi-VN:msg_done_port) echo "Cổng:" ;;
        vi-VN:msg_done_wbp) echo "Đường dẫn gốc Web:" ;;
        vi-VN:msg_done_db) echo "Cơ sở dữ liệu:" ;;
        vi-VN:msg_done_token) echo "Token API:" ;;
        vi-VN:msg_done_save) echo "QUAN TRỌNG: Hãy lưu thông tin đăng nhập này an toàn!" ;;
        vi-VN:msg_ssl_on) echo "Chứng chỉ SSL: Đã bật và đã cấu hình" ;;
        vi-VN:msg_ssl_off) echo "Chứng chỉ SSL: Đã bỏ qua - panel chỉ dùng HTTP. Hãy dùng reverse proxy hoặc SSH tunnel." ;;
        vi-VN:msg_pg_backup_title) echo "Sao lưu và khôi phục PostgreSQL được tích hợp sẵn trong panel:" ;;
        vi-VN:msg_pg_backup_menu) echo "→ Sao lưu & Khôi phục" ;;
        vi-VN:msg_pg_backup_note) echo "  Sao lưu tải xuống tệp .dump của pg_dump; Khôi phục nạp lại tệp đó bằng pg_restore." ;;
        vi-VN:msg_pg_creds_title) echo "Thông tin đăng nhập PostgreSQL" ;;
        vi-VN:msg_pg_db_name) echo "Tên cơ sở dữ liệu:" ;;
        vi-VN:msg_pg_username) echo "Tên người dùng:" ;;
        vi-VN:msg_pg_password) echo "Mật khẩu:" ;;
        vi-VN:msg_pg_host) echo "Máy chủ:" ;;
        vi-VN:msg_pg_port) echo "Cổng:" ;;
        vi-VN:msg_pg_dsn) echo "DSN:" ;;
        vi-VN:msg_pg_env_file) echo "Tệp env:" ;;
        vi-VN:msg_pg_connect) echo "Kết nối từ máy chủ này:" ;;
        vi-VN:msg_pg_as_superuser) echo "(với tư cách siêu người dùng postgres)" ;;
        vi-VN:msg_pg_env_read) printf "⚠ Panel đọc thông tin đăng nhập này từ %s.\n" "$@" ;;
        vi-VN:msg_pg_save_password) echo "⚠ Hãy lưu mật khẩu — nó không được lưu ở dạng văn bản thuần ở bất kỳ nơi nào khác." ;;
        vi-VN:msg_wbp_generating) echo "WebBasePath bị thiếu hoặc quá ngắn. Đang tạo giá trị mới..." ;;
        vi-VN:msg_wbp_new) printf "WebBasePath mới: %s\n" "$@" ;;
        vi-VN:msg_default_creds) echo "Phát hiện thông tin đăng nhập mặc định. Cần cập nhật bảo mật..." ;;
        vi-VN:msg_new_creds) echo "Đã tạo thông tin đăng nhập ngẫu nhiên mới:" ;;
        vi-VN:msg_creds_set) echo "Tên người dùng, Mật khẩu và WebBasePath đã được đặt đúng." ;;
        vi-VN:msg_ssl_already_configured) echo "Chứng chỉ SSL đã được cấu hình. Không cần thao tác gì." ;;
        vi-VN:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s, bỏ qua thiết lập tự động Fail2ban.\n" "$@" ;;
        vi-VN:msg_f2b_skipped_cli) echo "Không tìm thấy easyxray CLI; bỏ qua thiết lập tự động Fail2ban." ;;
        vi-VN:msg_f2b_skipped_old) echo "easyxray.sh này có trước lệnh easyxray setup-fail2ban; bỏ qua thiết lập tự động Fail2ban." ;;
        vi-VN:msg_f2b_setup) echo "Đang thiết lập Fail2ban cho tính năng giới hạn IP..." ;;
        vi-VN:msg_f2b_done) echo "Thiết lập Fail2ban hoàn tất." ;;
        vi-VN:msg_f2b_incomplete) echo "Thiết lập Fail2ban chưa hoàn tất; tính năng giới hạn IP vẫn tắt cho tới khi bạn chạy easyxray và mở menu giới hạn IP. Tiếp tục." ;;
        vi-VN:msg_systemd_hardening_note) printf "Lưu ý: systemd %s bỏ qua một phần cấu hình gia cố trong easyxray.service; panel vẫn khởi động.\n" "$@" ;;
        vi-VN:msg_systemd_hardening_missing) printf "      Không được áp dụng, cần systemd mới hơn: %s\n" "$@" ;;
        vi-VN:msg_systemd_hardening_alias) echo "      Các thư mục của panel vẫn ghi được nhờ ReadWriteDirectories=, một bí danh do script này cài đặt." ;;
        vi-VN:msg_systemd_hardening_rest) echo "      Phần còn lại của cấu hình gia cố vẫn có hiệu lực. Hãy nâng cấp systemd để áp dụng các mục trên." ;;
        vi-VN:msg_ws_warn_head) echo "Cảnh báo: các thư mục sau chứa khoảng trắng nên đã bị loại khỏi" ;;
        vi-VN:msg_ws_warn_detail) printf "         Tệp 10-easyxray-sandbox.conf: %s\n" "$@" ;;
        vi-VN:msg_ws_warn_tail) echo "         Panel không thể ghi vào chúng dưới sandbox của unit." ;;
        vi-VN:msg_sandbox_refresh_failed) printf "Cảnh báo: không thể làm mới %s/easyxray.service.d/10-easyxray-sandbox.conf.\n" "$@" ;;
        vi-VN:msg_sandbox_write_hint) echo "Nếu EASYXRAY_DB_FOLDER hoặc EASYXRAY_LOG_FOLDER trỏ ra ngoài /etc/easyxray và /var/log/easyxray, panel có thể không ghi được vào đó dưới ProtectSystem=full." ;;
        vi-VN:msg_checksum_none) echo "Bản phát hành này không công bố checksum, bỏ qua bước xác minh" ;;
        vi-VN:msg_checksum_download_failed) printf "Không tải được checksum cho %s (HTTP %s)\n" "$@" ;;
        vi-VN:msg_checksum_mismatch) printf "Checksum không khớp cho %s: mong đợi %s, nhận được %s\n" "$@" ;;
        vi-VN:msg_checksum_ok) printf "Đã xác minh checksum: %s\n" "$@" ;;
        vi-VN:msg_repo_file_missing) printf "%s không khả dụng cho %s (HTTP %s)\n" "$@" ;;
        vi-VN:msg_repo_file_missing_hint) echo "Hãy cài một bản phát hành có kèm tệp này, hoặc dev cho bản rolling. Bản cài đặt hiện có của bạn chưa bị thay đổi." ;;
        vi-VN:msg_version_fetch_failed) echo "Không lấy được phiên bản easyxray, có thể do giới hạn của GitHub API, vui lòng thử lại sau" ;;
        vi-VN:msg_latest_version) printf "Đã lấy phiên bản easyxray mới nhất: %s, bắt đầu cài đặt...\n" "$@" ;;
        vi-VN:msg_download_failed) echo "Tải easyxray thất bại, hãy đảm bảo máy chủ của bạn truy cập được GitHub" ;;
        vi-VN:msg_archive_empty) echo "Tệp lưu trữ bản phát hành easyxray tải về bị trống" ;;
        vi-VN:msg_dev_build) echo "Đang cài bản dev rolling (tag: dev-latest). Đây là bản phát hành trước theo từng commit, không phải bản ổn định." ;;
        vi-VN:msg_install_start) echo "Bắt đầu cài đặt" ;;
        vi-VN:msg_download_version_failed) printf "Tải easyxray %s thất bại, vui lòng kiểm tra xem phiên bản đó có tồn tại không\n" "$@" ;;
        vi-VN:msg_script_download_failed) echo "Tải easyxray.sh thất bại" ;;
        vi-VN:msg_script_empty) echo "easyxray.sh tải về bị trống" ;;
        vi-VN:msg_bin_backup_failed) echo "Không thể sao lưu bin/ -- các tệp tùy chỉnh ở đó sẽ không được giữ lại qua lần cập nhật này" ;;
        vi-VN:msg_extract_failed) echo "Giải nén tệp lưu trữ bản phát hành easyxray thất bại -- bản cài đặt trước đã bị xóa nên panel sẽ không khởi động cho tới khi khắc phục được; hãy thử chạy lại trình cài đặt" ;;
        vi-VN:msg_binary_missing) echo "Tệp lưu trữ easyxray đã giải nén thiếu tệp nhị phân easyxray -- bản cài đặt trước đã bị xóa nên panel sẽ không khởi động cho tới khi khắc phục được; hãy thử chạy lại trình cài đặt" ;;
        vi-VN:msg_bin_restored) printf "Đã khôi phục các tệp tùy chỉnh trong bin/ không có trong bản phát hành này: %s\n" "$@" ;;
        vi-VN:msg_script_install_failed) echo "Cài đặt easyxray.sh thất bại" ;;
        vi-VN:msg_gitignore_added) echo "Đã thêm EasyXray.db vào /etc/.gitignore cho etckeeper" ;;
        vi-VN:msg_gitignore_created) echo "Đã tạo /etc/.gitignore và thêm EasyXray.db cho etckeeper" ;;
        vi-VN:msg_rc_download_failed) echo "Tải easyxray.rc thất bại" ;;
        vi-VN:msg_rc_empty) echo "easyxray.rc tải về bị trống" ;;
        vi-VN:msg_rc_install_failed) echo "Cài đặt easyxray.rc thất bại" ;;
        vi-VN:msg_service_found) echo "Đã tìm thấy easyxray.service trong các tệp giải nén, đang cài đặt..." ;;
        vi-VN:msg_service_found_variant) printf "Đã tìm thấy easyxray.service.%s trong các tệp giải nén, đang cài đặt...\n" "$@" ;;
        vi-VN:msg_service_downloading) echo "Không tìm thấy tệp dịch vụ trong tar.gz, đang tải từ GitHub..." ;;
        vi-VN:msg_service_install_failed) printf "Cài đặt easyxray.service từ GitHub thất bại (%s) -- tarball của bản phát hành cũng không kèm tệp này\n" "$@" ;;
        vi-VN:msg_systemd_setup) echo "Đang thiết lập unit systemd..." ;;
        vi-VN:msg_service_file_failed) echo "Cài đặt tệp easyxray.service thất bại" ;;
        vi-VN:msg_installed_ok) echo "đã cài xong, hiện đang chạy..." ;;
        vi-VN:msg_running) echo "Đang chạy..." ;;
        vi-VN:msg_menu_admin) echo "Script quản trị" ;;
        vi-VN:msg_menu_start) echo "Khởi động" ;;
        vi-VN:msg_menu_stop) echo "Dừng" ;;
        vi-VN:msg_menu_restart) echo "Khởi động lại" ;;
        vi-VN:msg_menu_status) echo "Trạng thái hiện tại" ;;
        vi-VN:msg_menu_settings) echo "Cài đặt hiện tại" ;;
        vi-VN:msg_menu_enable) echo "Bật tự khởi động cùng hệ điều hành" ;;
        vi-VN:msg_menu_disable) echo "Tắt tự khởi động cùng hệ điều hành" ;;
        vi-VN:msg_menu_log) echo "Xem nhật ký" ;;
        vi-VN:msg_menu_banlog) echo "Xem nhật ký cấm của Fail2ban" ;;
        vi-VN:msg_menu_update) echo "Cập nhật" ;;
        vi-VN:msg_menu_legacy) echo "Phiên bản cũ" ;;
        vi-VN:msg_menu_install) echo "Cài đặt" ;;
        vi-VN:msg_menu_uninstall) echo "Gỡ cài đặt" ;;
        # ---- es-ES ----
        es-ES:msg_lang_menu_title) echo "Seleccione el idioma de instalación:" ;;
        es-ES:msg_lang_invalid) echo "Opción no válida; se mantiene el idioma actual." ;;
        es-ES:msg_root_required) echo "Error fatal: ejecute este script con privilegios de root" ;;
        es-ES:msg_menu_title) echo "Uso del menú de control de easyxray (subcomandos):" ;;
        es-ES:msg_unsupported_arch) echo "Arquitectura de CPU no compatible." ;;
        es-ES:msg_arch) printf "Arquitectura: %s\n" "$@" ;;
        es-ES:msg_os_check_failed) echo "¡No se pudo comprobar el sistema operativo, ponte en contacto con el autor!" ;;
        es-ES:msg_os_release) printf "La versión del sistema operativo es: %s\n" "$@" ;;
        es-ES:msg_cert_not_pem) echo "el certificado o la clave privada no es un archivo PEM legible" ;;
        es-ES:msg_cert_key_mismatch) echo "la clave privada no coincide con el certificado" ;;
        es-ES:msg_cert_file_unreadable) printf "El archivo del certificado falta, está vacío o no se puede leer: %s\n" "$@" ;;
        es-ES:msg_cert_key_unreadable) printf "El archivo de la clave privada falta, está vacío o no se puede leer: %s\n" "$@" ;;
        es-ES:msg_cert_cli_failed) printf "easyxray cert terminó con el código %s: %s\n" "$@" ;;
        es-ES:msg_cert_not_saved) printf "El panel no guardó el certificado (cert guardado=%s, key=%s)\n" "$@" ;;
        es-ES:msg_result_write_failed) printf "Advertencia: no se pudo escribir %s.\n" "$@" ;;
        es-ES:msg_result_written) printf "Resultado de la instalación escrito en %s (modo 600).\n" "$@" ;;
        es-ES:msg_pg_pgdg_fallback) printf "PostgreSQL %s no está disponible para este sistema; se instalará el PostgreSQL de la distribución en su lugar.\n" "$@" ;;
        es-ES:msg_pg_distro_unsupported) printf "Distribución no compatible para la instalación automática de PostgreSQL: %s\n" "$@" ;;
        es-ES:msg_pg_hba_warn) echo "Advertencia: no se pudo actualizar pg_hba.conf; puede que PostgreSQL rechace el inicio de sesión TCP del panel (autenticación ident)." ;;
        es-ES:msg_pg_cred_write_failed) printf "No se pudieron escribir las credenciales de PostgreSQL en %s\n" "$@" ;;
        es-ES:msg_pg_client_tools) echo "Instalando las herramientas cliente de PostgreSQL (pg_dump/pg_restore) para la copia de seguridad desde el panel..." ;;
        es-ES:msg_acme_installing_ssl) echo "Instalando acme.sh para la gestión de certificados SSL..." ;;
        es-ES:msg_acme_failed) echo "No se pudo instalar acme.sh" ;;
        es-ES:msg_acme_ok) echo "acme.sh se instaló correctamente" ;;
        es-ES:msg_ssl_setup_start) echo "Configurando el certificado SSL..." ;;
        es-ES:msg_acme_failed_skip) echo "No se pudo instalar acme.sh; se omite la configuración de SSL" ;;
        es-ES:msg_ssl_issuing_domain) printf "Emitiendo el certificado SSL para %s...\n" "$@" ;;
        es-ES:msg_ssl_port80_note) echo "Nota: el puerto 80 debe estar abierto y accesible desde internet" ;;
        es-ES:msg_ssl_issue_failed) printf "No se pudo emitir el certificado para %s\n" "$@" ;;
        es-ES:msg_ssl_retry_hint) echo "Asegúrate de que el puerto 80 esté abierto e inténtalo de nuevo más tarde con: easyxray" ;;
        es-ES:msg_ssl_install_failed) echo "No se pudo instalar el certificado" ;;
        es-ES:msg_ssl_installed) echo "¡Certificado SSL instalado y configurado correctamente!" ;;
        es-ES:msg_cert_files_not_found) echo "No se encontraron los archivos del certificado" ;;
        es-ES:msg_ipcert_setup) echo "Configurando el certificado IP de Let's Encrypt (perfil shortlived)..." ;;
        es-ES:msg_ipcert_validity_note) echo "Nota: los certificados IP son válidos durante ~6 días y se renuevan automáticamente." ;;
        es-ES:msg_ipcert_port_note) echo "El puerto de escucha predeterminado es el 80. Si eliges otro puerto, asegúrate de que el puerto 80 externo se redirija a él." ;;
        es-ES:msg_ipv4_required) echo "Se requiere una dirección IPv4" ;;
        es-ES:msg_ipv4_invalid) printf "Dirección IPv4 no válida: %s\n" "$@" ;;
        es-ES:msg_ipv6_included) printf "Incluyendo la dirección IPv6: %s\n" "$@" ;;
        es-ES:msg_acme_port_prompt) echo "Puerto para el listener HTTP-01 de ACME (predeterminado 80):" ;;
        es-ES:msg_port_invalid_fallback) echo "Se proporcionó un puerto no válido. Se usará el 80." ;;
        es-ES:msg_port_using) printf "Usando el puerto %s para la validación independiente.\n" "$@" ;;
        es-ES:msg_port_forward_note) printf "Recordatorio: Let's Encrypt sigue conectándose por el puerto 80; redirige el puerto 80 externo a %s.\n" "$@" ;;
        es-ES:msg_port_in_use) printf "El puerto %s está en uso.\n" "$@" ;;
        es-ES:msg_port_busy_ni) printf "El puerto %s está ocupado; no se puede continuar en modo no interactivo.\n" "$@" ;;
        es-ES:msg_acme_port_retry_prompt) echo "Introduce otro puerto para el listener standalone de acme.sh (déjalo vacío para cancelar):" ;;
        es-ES:msg_port_busy) printf "El puerto %s está ocupado; no se puede continuar.\n" "$@" ;;
        es-ES:msg_port_invalid) echo "Se proporcionó un puerto no válido." ;;
        es-ES:msg_port_free) printf "El puerto %s está libre y listo para la validación independiente.\n" "$@" ;;
        es-ES:msg_ipcert_issuing) printf "Emitiendo el certificado IP para %s...\n" "$@" ;;
        es-ES:msg_ipcert_issue_failed) echo "No se pudo emitir el certificado IP" ;;
        es-ES:msg_ipcert_port_hint) printf "Asegúrate de que el puerto %s sea accesible (o redirigido desde el puerto 80 externo)\n" "$@" ;;
        es-ES:msg_cert_issued_installing) echo "Certificado emitido correctamente, instalando..." ;;
        es-ES:msg_cert_files_missing) echo "No se encontraron los archivos del certificado después de la instalación" ;;
        es-ES:msg_cert_files_installed) echo "Archivos del certificado instalados correctamente" ;;
        es-ES:msg_cert_paths_setting) echo "Configurando las rutas del certificado para el panel..." ;;
        es-ES:msg_cert_files_at) echo "Los archivos del certificado están en:" ;;
        es-ES:msg_cert_file) echo "Archivo de certificado:" ;;
        es-ES:msg_cert_key) echo "Archivo de clave privada:" ;;
        es-ES:msg_cert_paths_ok) echo "Rutas del certificado configuradas para el panel" ;;
        es-ES:msg_ipcert_installed) echo "¡Certificado IP instalado y configurado correctamente!" ;;
        es-ES:msg_ipcert_autorenew) echo "Certificado válido durante ~6 días, se renueva automáticamente mediante la tarea cron de acme.sh." ;;
        es-ES:msg_acme_autorenew) echo "acme.sh renovará y recargará easyxray automáticamente antes de su vencimiento." ;;
        es-ES:msg_acme_installing) echo "Instalando acme.sh..." ;;
        es-ES:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain requiere un EASYXRAY_DOMAIN válido (se obtuvo: '%s').\n" "$@" ;;
        es-ES:msg_domain_prompt) echo "Introduzca su nombre de dominio: " ;;
        es-ES:msg_domain_empty) echo "El nombre de dominio no puede estar vacío. Inténtelo de nuevo." ;;
        es-ES:msg_domain_invalid) echo "Formato de dominio no válido. Introduzca un nombre de dominio válido." ;;
        es-ES:msg_domain_checking) printf "Tu dominio es: %s, comprobándolo...\n" "$@" ;;
        es-ES:msg_cert_existing_reuse) printf "Se encontró un certificado existente para %s, se reutilizará.\n" "$@" ;;
        es-ES:msg_acme_state_incomplete) printf "Se encontró un estado incompleto de acme.sh para %s (sin archivos de certificado válidos); se limpiará y se emitirá de nuevo.\n" "$@" ;;
        es-ES:msg_domain_ready) echo "Tu dominio ya está listo para emitir certificados..." ;;
        es-ES:msg_acme_port_choose_prompt) echo "Elige qué puerto usar (el predeterminado es el 80):" ;;
        es-ES:msg_port_input_invalid) printf "Tu entrada %s no es válida, se usará el puerto predeterminado 80.\n" "$@" ;;
        es-ES:msg_port_will_use) printf "Se usará el puerto: %s para emitir los certificados. Asegúrate de que este puerto esté abierto.\n" "$@" ;;
        es-ES:msg_panel_stopping) echo "Deteniendo el panel temporalmente..." ;;
        es-ES:msg_cert_issue_failed_logs) echo "No se pudo emitir el certificado, revisa los registros." ;;
        es-ES:msg_cert_issue_succeeded) echo "El certificado se emitió correctamente, instalando los certificados..." ;;
        es-ES:msg_cert_using_existing) echo "Usando el certificado existente, instalando los certificados..." ;;
        es-ES:msg_reloadcmd_default) echo "El --reloadcmd predeterminado para ACME es:" ;;
        es-ES:msg_reloadcmd_runs_on) echo "Este comando se ejecutará en cada emisión y renovación del certificado." ;;
        es-ES:msg_reloadcmd_modify_prompt) echo "¿Quieres modificar el --reloadcmd de ACME? (y/n):" ;;
        es-ES:msg_reloadcmd_preset) echo "Preajuste: systemctl reload nginx ; systemctl restart easyxray" ;;
        es-ES:msg_reloadcmd_custom) echo "Introduce tu propio comando" ;;
        es-ES:msg_reloadcmd_keep_default) echo "Mantener el reloadcmd predeterminado" ;;
        es-ES:msg_reloadcmd_option_prompt) echo "Elige una opción:" ;;
        es-ES:msg_reloadcmd_is_preset) echo "El reloadcmd es: systemctl reload nginx ; systemctl restart easyxray" ;;
        es-ES:msg_reloadcmd_order) echo "Se recomienda poner el reinicio de easyxray al final" ;;
        es-ES:msg_reloadcmd_custom_prompt) echo "Introduce tu reloadcmd personalizado:" ;;
        es-ES:msg_reloadcmd_is) printf "El reloadcmd es: %s\n" "$@" ;;
        es-ES:msg_reloadcmd_keeping) echo "Manteniendo el reloadcmd predeterminado" ;;
        es-ES:msg_cert_installed_autorenew) echo "Certificado instalado correctamente, habilitando la renovación automática..." ;;
        es-ES:msg_cert_install_failed_exit) echo "No se pudo instalar el certificado, saliendo." ;;
        es-ES:msg_autorenew_issues) echo "La configuración de la renovación automática tuvo problemas, detalles del certificado:" ;;
        es-ES:msg_autorenew_ok) echo "La renovación automática se realizó correctamente, detalles del certificado:" ;;
        es-ES:msg_cert_set_panel_prompt) echo "¿Quieres asignar este certificado al panel? (y/n):" ;;
        es-ES:msg_done_url) echo "URL de acceso:" ;;
        es-ES:msg_cert_restart) echo "El panel se reiniciará para aplicar el certificado SSL..." ;;
        es-ES:msg_cert_rejected) echo "Error: el panel rechazó el certificado, por lo que serviría HTTP sin cifrar." ;;
        es-ES:msg_skip_panel_path) echo "Se omite la configuración de la ruta del panel." ;;
        es-ES:msg_ssl_choose) echo "Elija el método de configuración del certificado SSL:" ;;
        es-ES:msg_ssl_opt1) echo "Let's Encrypt para dominio (validez de 90 días, renovación automática)" ;;
        es-ES:msg_ssl_opt2) echo "Let's Encrypt para dirección IP (validez de 6 días, renovación automática)" ;;
        es-ES:msg_ssl_opt3) echo "Certificado Digital SSL personalizado (Ruta a archivos existentes)" ;;
        es-ES:msg_ssl_opt4) echo "Omitir SSL (avanzado: solo tras proxy inverso o túnel SSH)" ;;
        es-ES:msg_ssl_note_opts) echo "Nota: las opciones 1 y 2 requieren el puerto 80 abierto. La opción 3 requiere rutas manuales." ;;
        es-ES:msg_ssl_note_opt4) echo "Nota: la opción 4 sirve el panel por HTTP sin cifrar; solo es segura detrás de nginx/Caddy o un túnel SSH." ;;
        es-ES:msg_ssl_mode_unknown) printf "EASYXRAY_SSL_MODE='%s' desconocido, se usará none (HTTP) de forma predeterminada.\n" "$@" ;;
        es-ES:msg_ssl_pick) echo "Elija una opción (por defecto 2 para IP): " ;;
        es-ES:msg_ssl_le_domain) echo "Usando Let's Encrypt para el certificado de dominio..." ;;
        es-ES:msg_ssl_domain_ok) printf "✓ Certificado SSL configurado correctamente con el dominio: %s\n" "$@" ;;
        es-ES:msg_ssl_domain_extract_failed) echo "Es posible que la configuración SSL se haya completado, pero falló la extracción del dominio" ;;
        es-ES:msg_ssl_domain_failed) echo "La configuración del certificado SSL falló en el modo dominio." ;;
        es-ES:msg_ssl_le_ip) echo "Usando Let's Encrypt para el certificado IP (perfil shortlived)..." ;;
        es-ES:msg_ipv4_confirm_prompt) printf "¿Es %s la dirección IPv4 pública entrante correcta de este servidor? [Default y]:\n" "$@" ;;
        es-ES:msg_ipv4_prompt) echo "Introduce la dirección IPv4 pública de tu servidor:" ;;
        es-ES:msg_ipv4_invalid_retry) echo "Dirección IPv4 no válida. Inténtalo de nuevo." ;;
        es-ES:msg_ipv6_prompt) echo "¿Tienes una dirección IPv6 que incluir? (déjalo vacío para omitir):" ;;
        es-ES:msg_ipcert_configured) echo "✓ Certificado IP de Let's Encrypt configurado correctamente" ;;
        es-ES:msg_ipcert_setup_failed) echo "✗ La configuración del certificado IP falló. Comprueba que el puerto 80 esté abierto." ;;
        es-ES:msg_custom_cert_using) echo "Usando el certificado personalizado existente..." ;;
        es-ES:msg_custom_cert_domain_prompt) echo "Introduce el nombre de dominio para el que se emitió el certificado:" ;;
        es-ES:msg_custom_cert_path_prompt) echo "Introduce la ruta del certificado (palabras clave: .crt / fullchain):" ;;
        es-ES:msg_file_missing) echo "Error: el archivo no existe. Inténtalo de nuevo." ;;
        es-ES:msg_file_unreadable) echo "Error: el archivo existe pero no se puede leer (comprueba los permisos)." ;;
        es-ES:msg_file_empty) echo "Error: el archivo está vacío." ;;
        es-ES:msg_custom_key_path_prompt) echo "Introduce la ruta de la clave privada (palabras clave: .key / privatekey):" ;;
        es-ES:msg_custom_cert_not_applied) echo "✗ No se aplicó el certificado personalizado; el panel serviría por HTTP sin cifrar." ;;
        es-ES:msg_custom_cert_applied) echo "✓ Rutas del certificado personalizado aplicadas." ;;
        es-ES:msg_custom_cert_renew_note) echo "Nota: eres responsable de renovar estos archivos de forma externa." ;;
        es-ES:msg_no_ssl_title) echo "⚠ El panel se instalará SIN SSL/TLS." ;;
        es-ES:msg_no_ssl_plaintext) echo "Las credenciales de acceso y las cookies viajarán por HTTP sin cifrar." ;;
        es-ES:msg_no_ssl_safe_when) echo "Solo es seguro cuando:" ;;
        es-ES:msg_no_ssl_proxy) echo "  • Un proxy inverso (nginx, Caddy, Traefik) termina el TLS por ti, o" ;;
        es-ES:msg_no_ssl_tunnel) echo "  • Accedes al panel exclusivamente mediante un túnel SSH" ;;
        es-ES:msg_bind_localhost_prompt) echo "¿Vincular el panel solo a 127.0.0.1? (recomendado — obliga a usar un túnel SSH o un proxy inverso) [y/N]:" ;;
        es-ES:msg_panel_localhost_only) echo "✓ Panel vinculado solo a 127.0.0.1. Ahora es inaccesible desde internet público." ;;
        es-ES:msg_ssh_forward_title) echo "Redirección de puertos SSH — abre el panel desde tu máquina local mediante:" ;;
        es-ES:msg_ssh_cmd_standard) echo "  Comando SSH estándar:" ;;
        es-ES:msg_ssh_cmd_key) echo "  Si usas una clave SSH:" ;;
        es-ES:msg_ssh_cmd_open) echo "  Luego abre en tu navegador:" ;;
        es-ES:msg_ssh_alt_proxy) printf "Alternativa: apunta un proxy inverso (nginx/Caddy) a 127.0.0.1:%s y deja que termine el TLS.\n" "$@" ;;
        es-ES:msg_no_ssl_all_interfaces) echo "El panel escuchará en todas las interfaces por HTTP sin cifrar. Asegúrate de que algo más termine el TLS delante de él." ;;
        es-ES:msg_ssl_skipped) echo "✓ Configuración SSL omitida." ;;
        es-ES:msg_ssl_option_invalid) echo "Opción no válida. Omitiendo la configuración SSL." ;;
        es-ES:msg_ip_detect_failed) echo "No se pudo detectar automáticamente la IP del servidor desde ningún proveedor." ;;
        es-ES:msg_db_selection_title) echo "Selección de base de datos" ;;
        es-ES:msg_db_opt_sqlite) echo "1) SQLite     (predeterminado — recomendado para menos de 500 clientes)" ;;
        es-ES:msg_db_opt_pg) echo "2) PostgreSQL (recomendado para un gran número de clientes / muchos nodos)" ;;
        es-ES:msg_choose_default) echo "Elige [1]:" ;;
        es-ES:msg_db_label_pg_external) echo "PostgreSQL (externo)" ;;
        es-ES:msg_pg_installing_local) echo "Instalando PostgreSQL localmente (no interactivo)..." ;;
        es-ES:msg_pg_failed_ni) echo "La instalación de PostgreSQL falló en modo no interactivo; abortando." ;;
        es-ES:msg_pg_env_hint) echo "Define EASYXRAY_DB_DSN para usar un servidor existente, o EASYXRAY_DB_TYPE=sqlite." ;;
        es-ES:msg_pg_menu_local) echo "1) Instalar PostgreSQL localmente y crear un usuario y una base de datos dedicados (recomendado)" ;;
        es-ES:msg_pg_menu_external) echo "2) Usar un servidor PostgreSQL existente (introducir el DSN)" ;;
        es-ES:msg_pg_dsn_prompt) echo "Introduce el DSN de PostgreSQL (postgres://user:pass@host:port/dbname?sslmode=disable):" ;;
        es-ES:msg_pg_installing) echo "Instalando PostgreSQL — esto puede tardar un momento..." ;;
        es-ES:msg_pg_credfile_failed) echo "No se pudo crear el archivo temporal de credenciales." ;;
        es-ES:msg_pg_failed) echo "La instalación de PostgreSQL falló." ;;
        es-ES:msg_pg_menu_retry) echo "1) Reintentar la instalación local" ;;
        es-ES:msg_pg_menu_dsn) echo "2) Introducir un DSN externo en su lugar" ;;
        es-ES:msg_pg_menu_abort) echo "3) Abortar la instalación" ;;
        es-ES:msg_pg_menu_fallback) echo "4) Usar SQLite como alternativa" ;;
        es-ES:msg_install_aborted) echo "Instalación abortada." ;;
        es-ES:msg_pg_client_missing) echo "⚠ No se pudo instalar pg_dump/pg_restore. La copia de seguridad y la restauración de la base de datos desde el panel no estarán disponibles hasta que instales el paquete postgresql-client." ;;
        es-ES:msg_panel_port) printf "El puerto de tu panel es: %s\n" "$@" ;;
        es-ES:msg_panel_port_random) printf "Puerto aleatorio generado: %s\n" "$@" ;;
        es-ES:msg_panel_port_customize_prompt) echo "¿Quieres personalizar la configuración del puerto del panel? (Si no, se aplicará un puerto aleatorio) [y/n]:" ;;
        es-ES:msg_panel_port_prompt) echo "Define el puerto del panel:" ;;
        es-ES:msg_ssl_title) echo "Configuración del certificado SSL (RECOMENDADO)" ;;
        es-ES:msg_ssl_recommend) echo "Se recomienda mucho usar SSL. Omítalo solo si un proxy inverso o túnel SSH gestiona el TLS." ;;
        es-ES:msg_ssl_le_note) echo "¡Let's Encrypt ya admite tanto dominios como direcciones IP!" ;;
        es-ES:msg_abort1) echo "No se pudo aplicar el certificado al panel, por lo que serviría HTTP sin cifrar tras una URL https://." ;;
        es-ES:msg_abort2) echo "No se cambió nada más; corrija el certificado y vuelva a ejecutar el instalador." ;;
        es-ES:msg_done_title) echo "¡Instalación del panel completada!" ;;
        es-ES:msg_done_user) echo "Nombre de Usuario:" ;;
        es-ES:msg_done_pass) echo "Contraseña:" ;;
        es-ES:msg_done_port) echo "Puerto:" ;;
        es-ES:msg_done_wbp) echo "Ruta base web:" ;;
        es-ES:msg_done_db) echo "Base de datos:" ;;
        es-ES:msg_done_token) echo "Token de API:" ;;
        es-ES:msg_done_save) echo "IMPORTANTE: ¡Guarde estas credenciales de forma segura!" ;;
        es-ES:msg_ssl_on) echo "Certificado SSL: habilitado y configurado" ;;
        es-ES:msg_ssl_off) echo "Certificado SSL: omitido; el panel solo usa HTTP. Use un proxy inverso o túnel SSH." ;;
        es-ES:msg_pg_backup_title) echo "La copia de seguridad y la restauración de PostgreSQL están integradas en el panel:" ;;
        es-ES:msg_pg_backup_menu) echo "→ Copia & Restauración" ;;
        es-ES:msg_pg_backup_note) echo "  Copia de seguridad descarga un archivo .dump de pg_dump; Restaurar lo vuelve a cargar con pg_restore." ;;
        es-ES:msg_pg_creds_title) echo "Credenciales de PostgreSQL" ;;
        es-ES:msg_pg_db_name) echo "Nombre de la base de datos:" ;;
        es-ES:msg_pg_username) echo "Nombre de usuario:" ;;
        es-ES:msg_pg_password) echo "Contraseña:" ;;
        es-ES:msg_pg_host) echo "Servidor:" ;;
        es-ES:msg_pg_port) echo "Puerto:" ;;
        es-ES:msg_pg_dsn) echo "DSN:" ;;
        es-ES:msg_pg_env_file) echo "Archivo de entorno:" ;;
        es-ES:msg_pg_connect) echo "Conectarse desde este servidor:" ;;
        es-ES:msg_pg_as_superuser) echo "(como el superusuario postgres)" ;;
        es-ES:msg_pg_env_read) printf "⚠ El panel lee estas credenciales desde %s.\n" "$@" ;;
        es-ES:msg_pg_save_password) echo "⚠ Guarda la contraseña; no se almacena en ningún otro lugar en texto plano." ;;
        es-ES:msg_wbp_generating) echo "WebBasePath falta o es demasiado corto. Generando uno nuevo..." ;;
        es-ES:msg_wbp_new) printf "Nuevo WebBasePath: %s\n" "$@" ;;
        es-ES:msg_default_creds) echo "Se detectaron credenciales predeterminadas. Se requiere una actualización de seguridad..." ;;
        es-ES:msg_new_creds) echo "Se generaron nuevas credenciales de acceso aleatorias:" ;;
        es-ES:msg_creds_set) echo "El nombre de usuario, la contraseña y WebBasePath están configurados correctamente." ;;
        es-ES:msg_ssl_already_configured) echo "El certificado SSL ya está configurado. No se requiere ninguna acción." ;;
        es-ES:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s, omitiendo la configuración automática de Fail2ban.\n" "$@" ;;
        es-ES:msg_f2b_skipped_cli) echo "No se encontró el CLI de easyxray; omitiendo la configuración automática de Fail2ban." ;;
        es-ES:msg_f2b_skipped_old) echo "Este easyxray.sh es anterior a 'easyxray setup-fail2ban'; omitiendo la configuración automática de Fail2ban." ;;
        es-ES:msg_f2b_setup) echo "Configurando Fail2ban para la función de límite de IP..." ;;
        es-ES:msg_f2b_done) echo "Configuración de Fail2ban completada." ;;
        es-ES:msg_f2b_incomplete) echo "La configuración de Fail2ban no finalizó; el límite de IP seguirá desactivado hasta que ejecutes 'easyxray' y abras el menú de límite de IP. Continuando." ;;
        es-ES:msg_systemd_hardening_note) printf "Nota: systemd %s ignora parte del endurecimiento de easyxray.service; el panel se inicia igualmente.\n" "$@" ;;
        es-ES:msg_systemd_hardening_missing) printf "      No aplicado, requiere un systemd más reciente: %s.\n" "$@" ;;
        es-ES:msg_systemd_hardening_alias) echo "      Las carpetas del panel siguen siendo escribibles mediante ReadWriteDirectories=, el alias que instala este script." ;;
        es-ES:msg_systemd_hardening_rest) echo "      El resto del endurecimiento está en vigor. Actualiza systemd para aplicar lo anterior." ;;
        es-ES:msg_ws_warn_head) echo "Advertencia: estas carpetas contienen espacios en blanco y se omitieron de" ;;
        es-ES:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf: %s\n" "$@" ;;
        es-ES:msg_ws_warn_tail) echo "         El panel no puede escribir en ellas bajo el sandbox de la unidad." ;;
        es-ES:msg_sandbox_refresh_failed) printf "Advertencia: no se pudo actualizar %s/easyxray.service.d/10-easyxray-sandbox.conf.\n" "$@" ;;
        es-ES:msg_sandbox_write_hint) echo "Si EASYXRAY_DB_FOLDER o EASYXRAY_LOG_FOLDER apunta fuera de /etc/easyxray y /var/log/easyxray, es posible que el panel no pueda escribir en él bajo ProtectSystem=full." ;;
        es-ES:msg_checksum_none) echo "No se publicó ninguna suma de comprobación para esta versión, omitiendo la verificación" ;;
        es-ES:msg_checksum_download_failed) printf "No se pudo descargar la suma de comprobación de %s (HTTP %s)\n" "$@" ;;
        es-ES:msg_checksum_mismatch) printf "La suma de comprobación no coincide para %s: se esperaba %s, se obtuvo %s\n" "$@" ;;
        es-ES:msg_checksum_ok) printf "Suma de comprobación verificada: %s\n" "$@" ;;
        es-ES:msg_repo_file_missing) printf "%s no está disponible para %s (HTTP %s)\n" "$@" ;;
        es-ES:msg_repo_file_missing_hint) echo "Instala una versión que lo incluya, o 'dev' para la compilación continua. Tu instalación existente no se ha modificado." ;;
        es-ES:msg_version_fetch_failed) echo "No se pudo obtener la versión de easyxray, puede deberse a restricciones de la API de GitHub; inténtalo más tarde" ;;
        es-ES:msg_latest_version) printf "Se obtuvo la última versión de easyxray: %s, comenzando la instalación...\n" "$@" ;;
        es-ES:msg_download_failed) echo "La descarga de easyxray falló; asegúrate de que tu servidor pueda acceder a GitHub" ;;
        es-ES:msg_archive_empty) echo "El archivo de la versión de easyxray descargado está vacío" ;;
        es-ES:msg_dev_build) echo "Instalando la compilación continua dev (etiqueta: dev-latest). Es una versión preliminar por commit, no una versión estable." ;;
        es-ES:msg_install_start) echo "Iniciando la instalación de" ;;
        es-ES:msg_download_version_failed) printf "La descarga de easyxray %s falló; comprueba si la versión existe\n" "$@" ;;
        es-ES:msg_script_download_failed) echo "No se pudo descargar easyxray.sh" ;;
        es-ES:msg_script_empty) echo "El easyxray.sh descargado está vacío" ;;
        es-ES:msg_bin_backup_failed) echo "No se pudo hacer copia de seguridad de bin/; los archivos personalizados que contiene no se conservarán durante esta actualización" ;;
        es-ES:msg_extract_failed) echo "No se pudo extraer el archivo de la versión de easyxray; la instalación anterior ya se eliminó, así que el panel no se iniciará hasta que esto se solucione; intenta ejecutar el instalador de nuevo" ;;
        es-ES:msg_binary_missing) echo "Al archivo extraído de easyxray le falta el binario easyxray; la instalación anterior ya se eliminó, así que el panel no se iniciará hasta que esto se solucione; intenta ejecutar el instalador de nuevo" ;;
        es-ES:msg_bin_restored) printf "Se restauraron los archivos personalizados de bin/ que esta versión no incluye: %s\n" "$@" ;;
        es-ES:msg_script_install_failed) echo "No se pudo instalar easyxray.sh" ;;
        es-ES:msg_gitignore_added) echo "Se añadió EasyXray.db a /etc/.gitignore para etckeeper" ;;
        es-ES:msg_gitignore_created) echo "Se creó /etc/.gitignore y se añadió EasyXray.db para etckeeper" ;;
        es-ES:msg_rc_download_failed) echo "No se pudo descargar easyxray.rc" ;;
        es-ES:msg_rc_empty) echo "El easyxray.rc descargado está vacío" ;;
        es-ES:msg_rc_install_failed) echo "No se pudo instalar easyxray.rc" ;;
        es-ES:msg_service_found) echo "Se encontró easyxray.service en los archivos extraídos, instalando..." ;;
        es-ES:msg_service_found_variant) printf "Se encontró easyxray.service.%s en los archivos extraídos, instalando...\n" "$@" ;;
        es-ES:msg_service_downloading) echo "No se encontraron los archivos de servicio en tar.gz, descargando desde GitHub..." ;;
        es-ES:msg_service_install_failed) printf "No se pudo instalar easyxray.service desde GitHub (%s); el tarball de la versión tampoco lo incluía\n" "$@" ;;
        es-ES:msg_systemd_setup) echo "Configurando la unidad de systemd..." ;;
        es-ES:msg_service_file_failed) echo "No se pudo instalar el archivo easyxray.service" ;;
        es-ES:msg_installed_ok) echo "instalación finalizada, ya está en ejecución..." ;;
        es-ES:msg_running) echo "Ejecutando..." ;;
        es-ES:msg_menu_admin) echo "Script de gestión administrativa" ;;
        es-ES:msg_menu_start) echo "Iniciar" ;;
        es-ES:msg_menu_stop) echo "Detener" ;;
        es-ES:msg_menu_restart) echo "Reiniciar" ;;
        es-ES:msg_menu_status) echo "Estado actual" ;;
        es-ES:msg_menu_settings) echo "Configuración actual" ;;
        es-ES:msg_menu_enable) echo "Habilitar el inicio automático al arrancar el sistema" ;;
        es-ES:msg_menu_disable) echo "Deshabilitar el inicio automático al arrancar el sistema" ;;
        es-ES:msg_menu_log) echo "Ver los registros" ;;
        es-ES:msg_menu_banlog) echo "Ver los registros de bloqueos de Fail2ban" ;;
        es-ES:msg_menu_update) echo "Actualizar" ;;
        es-ES:msg_menu_legacy) echo "Versión heredada" ;;
        es-ES:msg_menu_install) echo "Instalar" ;;
        es-ES:msg_menu_uninstall) echo "Desinstalar" ;;
        # ---- id-ID ----
        id-ID:msg_lang_menu_title) echo "Pilih bahasa instalasi:" ;;
        id-ID:msg_lang_invalid) echo "Pilihan tidak valid, tetap memakai bahasa saat ini." ;;
        id-ID:msg_root_required) echo "Kesalahan fatal: Jalankan skrip ini dengan hak akses root" ;;
        id-ID:msg_menu_title) echo "Cara pakai menu kontrol easyxray (subperintah):" ;;
        id-ID:msg_unsupported_arch) echo "Arsitektur CPU tidak didukung!" ;;
        id-ID:msg_arch) printf "Arsitektur: %s\n" "$@" ;;
        id-ID:msg_os_check_failed) echo "Gagal memeriksa sistem operasi, silakan hubungi penulisnya!" ;;
        id-ID:msg_os_release) printf "Rilis sistem operasi adalah: %s\n" "$@" ;;
        id-ID:msg_cert_not_pem) echo "Sertifikat atau kunci privat bukan berkas PEM yang dapat dibaca" ;;
        id-ID:msg_cert_key_mismatch) echo "Kunci privat tidak cocok dengan sertifikat" ;;
        id-ID:msg_cert_file_unreadable) printf "File sertifikat hilang, kosong, atau tidak dapat dibaca: %s\n" "$@" ;;
        id-ID:msg_cert_key_unreadable) printf "File kunci privat hilang, kosong, atau tidak dapat dibaca: %s\n" "$@" ;;
        id-ID:msg_cert_cli_failed) printf "easyxray cert keluar dengan kode %s: %s\n" "$@" ;;
        id-ID:msg_cert_not_saved) printf "Panel tidak menyimpan sertifikat (cert tersimpan=%s, key=%s)\n" "$@" ;;
        id-ID:msg_result_write_failed) printf "Peringatan: gagal menulis %s.\n" "$@" ;;
        id-ID:msg_result_written) printf "Hasil instalasi ditulis ke %s (mode 600).\n" "$@" ;;
        id-ID:msg_pg_pgdg_fallback) printf "PostgreSQL %s tidak tersedia untuk sistem ini; sebagai gantinya memasang PostgreSQL dari distribusi.\n" "$@" ;;
        id-ID:msg_pg_distro_unsupported) printf "Distro tidak didukung untuk instalasi PostgreSQL otomatis: %s\n" "$@" ;;
        id-ID:msg_pg_hba_warn) echo "Peringatan: tidak dapat memperbarui pg_hba.conf; PostgreSQL mungkin menolak login TCP panel (autentikasi ident)." ;;
        id-ID:msg_pg_cred_write_failed) printf "Gagal menulis kredensial PostgreSQL ke %s\n" "$@" ;;
        id-ID:msg_pg_client_tools) echo "Memasang alat klien PostgreSQL (pg_dump/pg_restore) untuk pencadangan di dalam panel..." ;;
        id-ID:msg_acme_installing_ssl) echo "Memasang acme.sh untuk pengelolaan sertifikat SSL..." ;;
        id-ID:msg_acme_failed) echo "Gagal menginstal acme.sh" ;;
        id-ID:msg_acme_ok) echo "acme.sh berhasil diinstal" ;;
        id-ID:msg_ssl_setup_start) echo "Menyiapkan sertifikat SSL..." ;;
        id-ID:msg_acme_failed_skip) echo "Gagal menginstal acme.sh, penyiapan SSL dilewati" ;;
        id-ID:msg_ssl_issuing_domain) printf "Menerbitkan sertifikat SSL untuk %s...\n" "$@" ;;
        id-ID:msg_ssl_port80_note) echo "Catatan: Port 80 harus terbuka dan dapat diakses dari internet" ;;
        id-ID:msg_ssl_issue_failed) printf "Gagal menerbitkan sertifikat untuk %s\n" "$@" ;;
        id-ID:msg_ssl_retry_hint) echo "Pastikan port 80 terbuka lalu coba lagi nanti dengan: easyxray" ;;
        id-ID:msg_ssl_install_failed) echo "Gagal memasang sertifikat" ;;
        id-ID:msg_ssl_installed) echo "Sertifikat SSL berhasil dipasang dan dikonfigurasi!" ;;
        id-ID:msg_cert_files_not_found) echo "Berkas sertifikat tidak ditemukan" ;;
        id-ID:msg_ipcert_setup) echo "Menyiapkan sertifikat IP Let's Encrypt (profil shortlived)..." ;;
        id-ID:msg_ipcert_validity_note) echo "Catatan: Sertifikat IP berlaku sekitar 6 hari dan diperpanjang otomatis." ;;
        id-ID:msg_ipcert_port_note) echo "Pendengar bawaan adalah port 80. Jika Anda memilih port lain, pastikan port 80 eksternal diteruskan ke port tersebut." ;;
        id-ID:msg_ipv4_required) echo "Alamat IPv4 wajib diisi" ;;
        id-ID:msg_ipv4_invalid) printf "Alamat IPv4 tidak valid: %s\n" "$@" ;;
        id-ID:msg_ipv6_included) printf "Menyertakan alamat IPv6: %s\n" "$@" ;;
        id-ID:msg_acme_port_prompt) echo "Port yang dipakai untuk pendengar ACME HTTP-01 (bawaan 80):" ;;
        id-ID:msg_port_invalid_fallback) echo "Port yang diberikan tidak valid. Kembali memakai 80." ;;
        id-ID:msg_port_using) printf "Memakai port %s untuk validasi mandiri.\n" "$@" ;;
        id-ID:msg_port_forward_note) printf "Pengingat: Let's Encrypt tetap terhubung melalui port 80; teruskan port 80 eksternal ke %s.\n" "$@" ;;
        id-ID:msg_port_in_use) printf "Port %s sedang dipakai.\n" "$@" ;;
        id-ID:msg_port_busy_ni) printf "Port %s sibuk; tidak dapat melanjutkan dalam mode non-interaktif.\n" "$@" ;;
        id-ID:msg_acme_port_retry_prompt) echo "Masukkan port lain untuk pendengar mandiri acme.sh (biarkan kosong untuk membatalkan):" ;;
        id-ID:msg_port_busy) printf "Port %s sibuk; tidak dapat melanjutkan.\n" "$@" ;;
        id-ID:msg_port_invalid) echo "Port yang diberikan tidak valid." ;;
        id-ID:msg_port_free) printf "Port %s bebas dan siap untuk validasi mandiri.\n" "$@" ;;
        id-ID:msg_ipcert_issuing) printf "Menerbitkan sertifikat IP untuk %s...\n" "$@" ;;
        id-ID:msg_ipcert_issue_failed) echo "Gagal menerbitkan sertifikat IP" ;;
        id-ID:msg_ipcert_port_hint) printf "Pastikan port %s dapat dijangkau (atau diteruskan dari port 80 eksternal)\n" "$@" ;;
        id-ID:msg_cert_issued_installing) echo "Sertifikat berhasil diterbitkan, memasang..." ;;
        id-ID:msg_cert_files_missing) echo "Berkas sertifikat tidak ditemukan setelah instalasi" ;;
        id-ID:msg_cert_files_installed) echo "Berkas sertifikat berhasil dipasang" ;;
        id-ID:msg_cert_paths_setting) echo "Mengatur path sertifikat untuk panel..." ;;
        id-ID:msg_cert_files_at) echo "Berkas sertifikat berada di:" ;;
        id-ID:msg_cert_file) echo "Berkas Sertifikat:" ;;
        id-ID:msg_cert_key) echo "Berkas Kunci Privat:" ;;
        id-ID:msg_cert_paths_ok) echo "Path sertifikat untuk panel telah disetel" ;;
        id-ID:msg_ipcert_installed) echo "Sertifikat IP berhasil dipasang dan dikonfigurasi!" ;;
        id-ID:msg_ipcert_autorenew) echo "Sertifikat berlaku sekitar 6 hari, diperpanjang otomatis lewat tugas cron acme.sh." ;;
        id-ID:msg_acme_autorenew) echo "acme.sh akan otomatis memperpanjang dan memuat ulang easyxray sebelum kedaluwarsa." ;;
        id-ID:msg_acme_installing) echo "Menginstal acme.sh..." ;;
        id-ID:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain memerlukan EASYXRAY_DOMAIN yang valid (diterima: '%s').\n" "$@" ;;
        id-ID:msg_domain_prompt) echo "Silakan masukkan nama domain Anda: " ;;
        id-ID:msg_domain_empty) echo "Nama domain tidak boleh kosong. Silakan coba lagi." ;;
        id-ID:msg_domain_invalid) echo "Format domain tidak valid. Masukkan nama domain yang benar." ;;
        id-ID:msg_domain_checking) printf "Domain Anda adalah: %s, memeriksanya...\n" "$@" ;;
        id-ID:msg_cert_existing_reuse) printf "Sertifikat yang sudah ada ditemukan untuk %s, akan dipakai kembali.\n" "$@" ;;
        id-ID:msg_acme_state_incomplete) printf "Ditemukan status acme.sh yang tidak lengkap untuk %s (tidak ada berkas sertifikat yang valid); membersihkannya dan menerbitkan ulang.\n" "$@" ;;
        id-ID:msg_domain_ready) echo "Domain Anda kini siap untuk penerbitan sertifikat..." ;;
        id-ID:msg_acme_port_choose_prompt) echo "Silakan pilih port yang akan dipakai (bawaannya 80):" ;;
        id-ID:msg_port_input_invalid) printf "Masukan Anda %s tidak valid, akan memakai port bawaan 80.\n" "$@" ;;
        id-ID:msg_port_will_use) printf "Akan memakai port: %s untuk menerbitkan sertifikat. Pastikan port ini terbuka.\n" "$@" ;;
        id-ID:msg_panel_stopping) echo "Menghentikan panel untuk sementara..." ;;
        id-ID:msg_cert_issue_failed_logs) echo "Penerbitan sertifikat gagal, silakan periksa log." ;;
        id-ID:msg_cert_issue_succeeded) echo "Penerbitan sertifikat berhasil, memasang sertifikat..." ;;
        id-ID:msg_cert_using_existing) echo "Memakai sertifikat yang sudah ada, memasang sertifikat..." ;;
        id-ID:msg_reloadcmd_default) echo "Nilai bawaan --reloadcmd untuk ACME adalah:" ;;
        id-ID:msg_reloadcmd_runs_on) echo "Perintah ini akan dijalankan setiap kali sertifikat diterbitkan dan diperpanjang." ;;
        id-ID:msg_reloadcmd_modify_prompt) echo "Apakah Anda ingin mengubah --reloadcmd untuk ACME? (y/n):" ;;
        id-ID:msg_reloadcmd_preset) echo "Prasetel: systemctl reload nginx ; systemctl restart easyxray" ;;
        id-ID:msg_reloadcmd_custom) echo "Masukkan perintah Anda sendiri" ;;
        id-ID:msg_reloadcmd_keep_default) echo "Pertahankan reloadcmd bawaan" ;;
        id-ID:msg_reloadcmd_option_prompt) echo "Pilih salah satu opsi:" ;;
        id-ID:msg_reloadcmd_is_preset) echo "Reloadcmd adalah: systemctl reload nginx ; systemctl restart easyxray" ;;
        id-ID:msg_reloadcmd_order) echo "Sebaiknya taruh restart easyxray di bagian akhir" ;;
        id-ID:msg_reloadcmd_custom_prompt) echo "Silakan masukkan reloadcmd kustom Anda:" ;;
        id-ID:msg_reloadcmd_is) printf "Reloadcmd adalah: %s\n" "$@" ;;
        id-ID:msg_reloadcmd_keeping) echo "Mempertahankan reloadcmd bawaan" ;;
        id-ID:msg_cert_installed_autorenew) echo "Pemasangan sertifikat berhasil, mengaktifkan perpanjangan otomatis..." ;;
        id-ID:msg_cert_install_failed_exit) echo "Pemasangan sertifikat gagal, keluar." ;;
        id-ID:msg_autorenew_issues) echo "Penyiapan perpanjangan otomatis bermasalah, detail sertifikat:" ;;
        id-ID:msg_autorenew_ok) echo "Perpanjangan otomatis berhasil, detail sertifikat:" ;;
        id-ID:msg_cert_set_panel_prompt) echo "Apakah Anda ingin mengatur sertifikat ini untuk panel? (y/n):" ;;
        id-ID:msg_done_url) echo "URL Akses:" ;;
        id-ID:msg_cert_restart) echo "Panel akan dimulai ulang untuk menerapkan sertifikat SSL..." ;;
        id-ID:msg_cert_rejected) echo "Kesalahan: panel menolak sertifikat, jadi panel melayani HTTP biasa." ;;
        id-ID:msg_skip_panel_path) echo "Melewati pengaturan path panel." ;;
        id-ID:msg_ssl_choose) echo "Pilih metode penyiapan sertifikat SSL:" ;;
        id-ID:msg_ssl_opt1) echo "Let's Encrypt untuk Domain (berlaku 90 hari, diperbarui otomatis)" ;;
        id-ID:msg_ssl_opt2) echo "Let's Encrypt untuk Alamat IP (berlaku 6 hari, diperbarui otomatis)" ;;
        id-ID:msg_ssl_opt3) echo "Sertifikat SSL Kustom (Path ke berkas yang sudah ada)" ;;
        id-ID:msg_ssl_opt4) echo "Lewati SSL (lanjutan - hanya di balik reverse proxy / SSH tunnel)" ;;
        id-ID:msg_ssl_note_opts) echo "Catatan: Opsi 1 dan 2 memerlukan port 80 terbuka. Opsi 3 memerlukan path manual." ;;
        id-ID:msg_ssl_note_opt4) echo "Catatan: Opsi 4 menyajikan panel lewat HTTP biasa - hanya aman di belakang nginx/Caddy atau tunnel SSH." ;;
        id-ID:msg_ssl_mode_unknown) printf "EASYXRAY_SSL_MODE='%s' tidak dikenal, memakai bawaan none (HTTP).\n" "$@" ;;
        id-ID:msg_ssl_pick) echo "Pilih opsi (bawaan 2 untuk IP): " ;;
        id-ID:msg_ssl_le_domain) echo "Memakai Let's Encrypt untuk sertifikat domain..." ;;
        id-ID:msg_ssl_domain_ok) printf "✓ Sertifikat SSL berhasil dikonfigurasi dengan domain: %s\n" "$@" ;;
        id-ID:msg_ssl_domain_extract_failed) echo "Penyiapan SSL mungkin sudah selesai, tetapi ekstraksi domain gagal" ;;
        id-ID:msg_ssl_domain_failed) echo "Penyiapan sertifikat SSL gagal untuk mode domain." ;;
        id-ID:msg_ssl_le_ip) echo "Memakai Let's Encrypt untuk sertifikat IP (profil shortlived)..." ;;
        id-ID:msg_ipv4_confirm_prompt) printf "Apakah %s alamat IPv4 publik masuk yang benar untuk server ini? [Default y]:\n" "$@" ;;
        id-ID:msg_ipv4_prompt) echo "Silakan masukkan alamat IPv4 publik server Anda:" ;;
        id-ID:msg_ipv4_invalid_retry) echo "Alamat IPv4 tidak valid. Silakan coba lagi." ;;
        id-ID:msg_ipv6_prompt) echo "Apakah Anda memiliki alamat IPv6 untuk disertakan? (biarkan kosong untuk melewati):" ;;
        id-ID:msg_ipcert_configured) echo "✓ Sertifikat IP Let's Encrypt berhasil dikonfigurasi" ;;
        id-ID:msg_ipcert_setup_failed) echo "✗ Penyiapan sertifikat IP gagal. Pastikan port 80 terbuka." ;;
        id-ID:msg_custom_cert_using) echo "Memakai sertifikat kustom yang sudah ada..." ;;
        id-ID:msg_custom_cert_domain_prompt) echo "Silakan masukkan nama domain tempat sertifikat diterbitkan:" ;;
        id-ID:msg_custom_cert_path_prompt) echo "Masukkan path sertifikat (kata kunci: .crt / fullchain):" ;;
        id-ID:msg_file_missing) echo "Error: Berkas tidak ada! Coba lagi." ;;
        id-ID:msg_file_unreadable) echo "Error: Berkas ada tetapi tidak dapat dibaca (periksa izin)!" ;;
        id-ID:msg_file_empty) echo "Error: Berkas kosong!" ;;
        id-ID:msg_custom_key_path_prompt) echo "Masukkan path kunci privat (kata kunci: .key / privatekey):" ;;
        id-ID:msg_custom_cert_not_applied) echo "✗ Sertifikat kustom tidak diterapkan -- panel akan menyajikan HTTP biasa." ;;
        id-ID:msg_custom_cert_applied) echo "✓ Path sertifikat kustom sudah diterapkan." ;;
        id-ID:msg_custom_cert_renew_note) echo "Catatan: Anda sendiri yang bertanggung jawab memperpanjang berkas ini secara eksternal." ;;
        id-ID:msg_no_ssl_title) echo "⚠ Panel akan dipasang TANPA SSL/TLS." ;;
        id-ID:msg_no_ssl_plaintext) echo "Kredensial masuk dan cookie akan dikirim melalui HTTP biasa." ;;
        id-ID:msg_no_ssl_safe_when) echo "Hanya aman jika:" ;;
        id-ID:msg_no_ssl_proxy) echo "  • Sebuah reverse proxy (nginx, Caddy, Traefik) yang mengakhiri TLS untuk Anda, atau" ;;
        id-ID:msg_no_ssl_tunnel) echo "  • Anda mengakses panel hanya melalui tunnel SSH" ;;
        id-ID:msg_bind_localhost_prompt) echo "Ikat panel hanya ke 127.0.0.1? (disarankan — memaksa akses lewat tunnel SSH / reverse proxy) [y/N]:" ;;
        id-ID:msg_panel_localhost_only) echo "✓ Panel hanya terikat ke 127.0.0.1. Kini tidak dapat dijangkau dari internet publik." ;;
        id-ID:msg_ssh_forward_title) echo "Penerusan Port SSH — buka panel dari komputer lokal Anda melalui:" ;;
        id-ID:msg_ssh_cmd_standard) echo "  Perintah SSH standar:" ;;
        id-ID:msg_ssh_cmd_key) echo "  Jika memakai kunci SSH:" ;;
        id-ID:msg_ssh_cmd_open) echo "  Lalu buka di browser Anda:" ;;
        id-ID:msg_ssh_alt_proxy) printf "Alternatif: arahkan reverse proxy (nginx/Caddy) ke 127.0.0.1:%s dan biarkan ia mengakhiri TLS.\n" "$@" ;;
        id-ID:msg_no_ssl_all_interfaces) echo "Panel akan mendengarkan di semua antarmuka melalui HTTP biasa. Pastikan ada pihak lain yang mengakhiri TLS di depannya." ;;
        id-ID:msg_ssl_skipped) echo "✓ Penyiapan SSL dilewati." ;;
        id-ID:msg_ssl_option_invalid) echo "Opsi tidak valid. Melewati penyiapan SSL." ;;
        id-ID:msg_ip_detect_failed) echo "Tidak dapat mendeteksi IP server secara otomatis dari penyedia mana pun." ;;
        id-ID:msg_db_selection_title) echo "Pemilihan Database" ;;
        id-ID:msg_db_opt_sqlite) echo "1) SQLite     (bawaan — disarankan untuk kurang dari 500 klien)" ;;
        id-ID:msg_db_opt_pg) echo "2) PostgreSQL (disarankan untuk jumlah klien besar / banyak node)" ;;
        id-ID:msg_choose_default) echo "Pilih [1]:" ;;
        id-ID:msg_db_label_pg_external) echo "PostgreSQL (eksternal)" ;;
        id-ID:msg_pg_installing_local) echo "Memasang PostgreSQL secara lokal (non-interaktif)..." ;;
        id-ID:msg_pg_failed_ni) echo "Instalasi PostgreSQL gagal dalam mode non-interaktif; dibatalkan." ;;
        id-ID:msg_pg_env_hint) echo "Setel EASYXRAY_DB_DSN untuk memakai server yang sudah ada, atau EASYXRAY_DB_TYPE=sqlite." ;;
        id-ID:msg_pg_menu_local) echo "1) Pasang PostgreSQL secara lokal dan buat pengguna/database khusus (disarankan)" ;;
        id-ID:msg_pg_menu_external) echo "2) Pakai server PostgreSQL yang sudah ada (masukkan DSN)" ;;
        id-ID:msg_pg_dsn_prompt) echo "Masukkan DSN PostgreSQL (postgres://user:pass@host:port/dbname?sslmode=disable):" ;;
        id-ID:msg_pg_installing) echo "Memasang PostgreSQL — ini mungkin butuh beberapa saat..." ;;
        id-ID:msg_pg_credfile_failed) echo "Gagal membuat berkas kredensial sementara." ;;
        id-ID:msg_pg_failed) echo "Instalasi PostgreSQL gagal." ;;
        id-ID:msg_pg_menu_retry) echo "1) Coba lagi instalasi lokal" ;;
        id-ID:msg_pg_menu_dsn) echo "2) Masukkan DSN eksternal sebagai gantinya" ;;
        id-ID:msg_pg_menu_abort) echo "3) Batalkan instalasi" ;;
        id-ID:msg_pg_menu_fallback) echo "4) Beralih ke SQLite" ;;
        id-ID:msg_install_aborted) echo "Instalasi dibatalkan." ;;
        id-ID:msg_pg_client_missing) echo "⚠ Gagal memasang pg_dump/pg_restore. Pencadangan/pemulihan database di dalam panel tidak akan tersedia sampai Anda memasang paket postgresql-client." ;;
        id-ID:msg_panel_port) printf "Port Panel Anda adalah: %s\n" "$@" ;;
        id-ID:msg_panel_port_random) printf "Menghasilkan port acak: %s\n" "$@" ;;
        id-ID:msg_panel_port_customize_prompt) echo "Apakah Anda ingin menyesuaikan pengaturan Port Panel? (Jika tidak, port acak akan diterapkan) [y/n]:" ;;
        id-ID:msg_panel_port_prompt) echo "Silakan atur port panel:" ;;
        id-ID:msg_ssl_title) echo "Penyiapan Sertifikat Digital SSL (DISARANKAN)" ;;
        id-ID:msg_ssl_recommend) echo "SSL sangat disarankan. Lewati hanya jika reverse proxy atau SSH tunnel menangani TLS untuk Anda." ;;
        id-ID:msg_ssl_le_note) echo "Let's Encrypt kini mendukung domain maupun alamat IP!" ;;
        id-ID:msg_abort1) echo "Sertifikat tidak dapat diterapkan ke panel, jadi panel melayani HTTP biasa di balik URL https://." ;;
        id-ID:msg_abort2) echo "Tidak ada hal lain yang diubah; perbaiki sertifikat lalu jalankan penginstal lagi." ;;
        id-ID:msg_done_title) echo "Instalasi Panel Selesai!" ;;
        id-ID:msg_done_user) echo "Nama Pengguna:" ;;
        id-ID:msg_done_pass) echo "Kata Sandi:" ;;
        id-ID:msg_done_port) echo "Nomor Port:" ;;
        id-ID:msg_done_wbp) echo "Path Dasar Web:" ;;
        id-ID:msg_done_db) echo "Basis Data:" ;;
        id-ID:msg_done_token) echo "Token API:" ;;
        id-ID:msg_done_save) echo "PENTING: Simpan kredensial ini dengan aman!" ;;
        id-ID:msg_ssl_on) echo "Sertifikat SSL: Aktif dan telah dikonfigurasi" ;;
        id-ID:msg_ssl_off) echo "Sertifikat SSL: Dilewati - panel hanya HTTP. Gunakan reverse proxy atau SSH tunnel." ;;
        id-ID:msg_pg_backup_title) echo "Pencadangan dan pemulihan PostgreSQL sudah tersedia di dalam panel:" ;;
        id-ID:msg_pg_backup_menu) echo "→ Cadangkan & Pulihkan" ;;
        id-ID:msg_pg_backup_note) echo "  Cadangkan mengunduh berkas .dump dari pg_dump; Pulihkan memuatnya kembali dengan pg_restore." ;;
        id-ID:msg_pg_creds_title) echo "Kredensial PostgreSQL" ;;
        id-ID:msg_pg_db_name) echo "Nama Database:" ;;
        id-ID:msg_pg_username) echo "Nama Pengguna:" ;;
        id-ID:msg_pg_password) echo "Kata Sandi:" ;;
        id-ID:msg_pg_host) echo "Alamat Host:" ;;
        id-ID:msg_pg_port) echo "Nomor Port:" ;;
        id-ID:msg_pg_dsn) echo "DSN:" ;;
        id-ID:msg_pg_env_file) echo "Berkas env:" ;;
        id-ID:msg_pg_connect) echo "Hubungkan dari server ini:" ;;
        id-ID:msg_pg_as_superuser) echo "(sebagai superuser postgres)" ;;
        id-ID:msg_pg_env_read) printf "⚠ Panel membaca kredensial ini dari %s.\n" "$@" ;;
        id-ID:msg_pg_save_password) echo "⚠ Simpan kata sandinya — tidak disimpan lagi di tempat lain dalam bentuk teks biasa." ;;
        id-ID:msg_wbp_generating) echo "WebBasePath hilang atau terlalu pendek. Membuat yang baru..." ;;
        id-ID:msg_wbp_new) printf "WebBasePath baru: %s\n" "$@" ;;
        id-ID:msg_default_creds) echo "Kredensial bawaan terdeteksi. Perlu pembaruan keamanan..." ;;
        id-ID:msg_new_creds) echo "Menghasilkan kredensial masuk acak yang baru:" ;;
        id-ID:msg_creds_set) echo "Nama Pengguna, Kata Sandi, dan WebBasePath sudah diatur dengan benar." ;;
        id-ID:msg_ssl_already_configured) echo "Sertifikat SSL sudah dikonfigurasi. Tidak perlu tindakan." ;;
        id-ID:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s, melewati penyiapan otomatis Fail2ban.\n" "$@" ;;
        id-ID:msg_f2b_skipped_cli) echo "CLI easyxray tidak ditemukan; melewati penyiapan otomatis Fail2ban." ;;
        id-ID:msg_f2b_skipped_old) echo "easyxray.sh ini lebih tua dari 'easyxray setup-fail2ban'; melewati penyiapan otomatis Fail2ban." ;;
        id-ID:msg_f2b_setup) echo "Menyiapkan Fail2ban untuk fitur Batas IP..." ;;
        id-ID:msg_f2b_done) echo "Penyiapan Fail2ban selesai." ;;
        id-ID:msg_f2b_incomplete) echo "Penyiapan Fail2ban tidak selesai; Batas IP tetap nonaktif sampai Anda menjalankan 'easyxray' dan membuka menu Batas IP. Melanjutkan." ;;
        id-ID:msg_systemd_hardening_note) printf "Catatan: systemd %s mengabaikan sebagian pengerasan di easyxray.service; panel tetap dijalankan.\n" "$@" ;;
        id-ID:msg_systemd_hardening_missing) printf "      Tidak diterapkan, memerlukan systemd yang lebih baru: %s.\n" "$@" ;;
        id-ID:msg_systemd_hardening_alias) echo "      Folder panel tetap dapat ditulis melalui ReadWriteDirectories=, alias yang dipasang skrip ini." ;;
        id-ID:msg_systemd_hardening_rest) echo "      Sisa pengerasan tetap berlaku. Tingkatkan systemd untuk menerapkan hal di atas." ;;
        id-ID:msg_ws_warn_head) echo "Peringatan: folder-folder ini mengandung spasi dan dikecualikan dari" ;;
        id-ID:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf: %s\n" "$@" ;;
        id-ID:msg_ws_warn_tail) echo "         Panel tidak dapat menulis ke folder tersebut di bawah sandbox unit." ;;
        id-ID:msg_sandbox_refresh_failed) printf "Peringatan: tidak dapat menyegarkan %s/easyxray.service.d/10-easyxray-sandbox.conf.\n" "$@" ;;
        id-ID:msg_sandbox_write_hint) echo "Jika EASYXRAY_DB_FOLDER atau EASYXRAY_LOG_FOLDER menunjuk ke luar /etc/easyxray dan /var/log/easyxray, panel mungkin tidak dapat menulis ke sana di bawah ProtectSystem=full." ;;
        id-ID:msg_checksum_none) echo "Tidak ada checksum yang diterbitkan untuk rilis ini, melewati verifikasi" ;;
        id-ID:msg_checksum_download_failed) printf "Gagal mengunduh checksum untuk %s (HTTP %s)\n" "$@" ;;
        id-ID:msg_checksum_mismatch) printf "Checksum tidak cocok untuk %s: diharapkan %s, diterima %s\n" "$@" ;;
        id-ID:msg_checksum_ok) printf "Checksum terverifikasi: %s\n" "$@" ;;
        id-ID:msg_repo_file_missing) printf "%s tidak tersedia untuk %s (HTTP %s)\n" "$@" ;;
        id-ID:msg_repo_file_missing_hint) echo "Pasang rilis yang menyertakannya, atau 'dev' untuk build bergulir. Instalasi Anda yang sekarang tidak diubah." ;;
        id-ID:msg_version_fetch_failed) echo "Gagal mengambil versi easyxray, mungkin karena pembatasan API GitHub, silakan coba lagi nanti" ;;
        id-ID:msg_latest_version) printf "Mendapatkan versi terbaru easyxray: %s, memulai instalasi...\n" "$@" ;;
        id-ID:msg_download_failed) echo "Mengunduh easyxray gagal, pastikan server Anda dapat mengakses GitHub" ;;
        id-ID:msg_archive_empty) echo "Arsip rilis easyxray yang diunduh kosong" ;;
        id-ID:msg_dev_build) echo "Memasang build dev bergulir (tag: dev-latest). Ini pra-rilis per-commit, bukan versi stabil." ;;
        id-ID:msg_install_start) echo "Memulai instalasi" ;;
        id-ID:msg_download_version_failed) printf "Mengunduh easyxray %s gagal, silakan periksa apakah versi tersebut ada\n" "$@" ;;
        id-ID:msg_script_download_failed) echo "Gagal mengunduh easyxray.sh" ;;
        id-ID:msg_script_empty) echo "easyxray.sh yang diunduh kosong" ;;
        id-ID:msg_bin_backup_failed) echo "Tidak dapat mencadangkan bin/ -- berkas kustom di sana tidak akan dipertahankan selama pembaruan ini" ;;
        id-ID:msg_extract_failed) echo "Gagal mengekstrak arsip rilis easyxray -- instalasi sebelumnya sudah dihapus, jadi panel tidak akan berjalan sampai ini diperbaiki; coba jalankan penginstal sekali lagi" ;;
        id-ID:msg_binary_missing) echo "Arsip easyxray yang diekstrak tidak memuat biner easyxray -- instalasi sebelumnya sudah dihapus, jadi panel tidak akan berjalan sampai ini diperbaiki; coba jalankan penginstal sekali lagi" ;;
        id-ID:msg_bin_restored) printf "Memulihkan berkas kustom di bin/ yang tidak disertakan rilis ini: %s\n" "$@" ;;
        id-ID:msg_script_install_failed) echo "Gagal memasang easyxray.sh" ;;
        id-ID:msg_gitignore_added) echo "Menambahkan EasyXray.db ke /etc/.gitignore untuk etckeeper" ;;
        id-ID:msg_gitignore_created) echo "Membuat /etc/.gitignore dan menambahkan EasyXray.db untuk etckeeper" ;;
        id-ID:msg_rc_download_failed) echo "Gagal mengunduh easyxray.rc" ;;
        id-ID:msg_rc_empty) echo "easyxray.rc yang diunduh kosong" ;;
        id-ID:msg_rc_install_failed) echo "Gagal memasang easyxray.rc" ;;
        id-ID:msg_service_found) echo "Menemukan easyxray.service di berkas yang diekstrak, memasang..." ;;
        id-ID:msg_service_found_variant) printf "Menemukan easyxray.service.%s di berkas yang diekstrak, memasang...\n" "$@" ;;
        id-ID:msg_service_downloading) echo "Berkas layanan tidak ditemukan di dalam tar.gz, mengunduh dari GitHub..." ;;
        id-ID:msg_service_install_failed) printf "Gagal memasang easyxray.service dari GitHub (%s) -- tarball rilis juga tidak menyertakannya\n" "$@" ;;
        id-ID:msg_systemd_setup) echo "Menyiapkan unit systemd..." ;;
        id-ID:msg_service_file_failed) echo "Gagal memasang berkas easyxray.service" ;;
        id-ID:msg_installed_ok) echo "selesai diinstal, sekarang sedang berjalan..." ;;
        id-ID:msg_running) echo "Berjalan..." ;;
        id-ID:msg_menu_admin) echo "Skrip Manajemen Admin" ;;
        id-ID:msg_menu_start) echo "Mulai" ;;
        id-ID:msg_menu_stop) echo "Hentikan" ;;
        id-ID:msg_menu_restart) echo "Mulai ulang" ;;
        id-ID:msg_menu_status) echo "Status Saat Ini" ;;
        id-ID:msg_menu_settings) echo "Pengaturan Saat Ini" ;;
        id-ID:msg_menu_enable) echo "Aktifkan Mulai Otomatis saat Sistem Operasi Dinyalakan" ;;
        id-ID:msg_menu_disable) echo "Nonaktifkan Mulai Otomatis saat Sistem Operasi Dinyalakan" ;;
        id-ID:msg_menu_log) echo "Periksa log" ;;
        id-ID:msg_menu_banlog) echo "Periksa log pemblokiran Fail2ban" ;;
        id-ID:msg_menu_update) echo "Perbarui" ;;
        id-ID:msg_menu_legacy) echo "Versi lama" ;;
        id-ID:msg_menu_install) echo "Instal" ;;
        id-ID:msg_menu_uninstall) echo "Copot Instalasi" ;;
        # ---- uk-UA ----
        uk-UA:msg_lang_menu_title) echo "Виберіть мову встановлення:" ;;
        uk-UA:msg_lang_invalid) echo "Невірний вибір, залишається поточна мова." ;;
        uk-UA:msg_root_required) echo "Критична помилка: запустіть цей скрипт із правами root" ;;
        uk-UA:msg_menu_title) echo "Використання меню керування easyxray (підкоманди):" ;;
        uk-UA:msg_unsupported_arch) echo "Непідтримувана архітектура CPU!" ;;
        uk-UA:msg_arch) printf "Архітектура: %s\n" "$@" ;;
        uk-UA:msg_os_check_failed) echo "Не вдалося визначити операційну систему, зверніться до автора!" ;;
        uk-UA:msg_os_release) printf "Версія операційної системи: %s\n" "$@" ;;
        uk-UA:msg_cert_not_pem) echo "сертифікат або закритий ключ не є читабельним PEM-файлом" ;;
        uk-UA:msg_cert_key_mismatch) echo "закритий ключ не відповідає сертифікату" ;;
        uk-UA:msg_cert_file_unreadable) printf "Файл сертифіката відсутній, порожній або недоступний для читання: %s\n" "$@" ;;
        uk-UA:msg_cert_key_unreadable) printf "Файл закритого ключа відсутній, порожній або недоступний для читання: %s\n" "$@" ;;
        uk-UA:msg_cert_cli_failed) printf "easyxray cert завершився з кодом %s: %s\n" "$@" ;;
        uk-UA:msg_cert_not_saved) printf "Панель не зберегла сертифікат (збережений cert=%s, key=%s)\n" "$@" ;;
        uk-UA:msg_result_write_failed) printf "Увага: не вдалося записати %s.\n" "$@" ;;
        uk-UA:msg_result_written) printf "Результат встановлення записано у %s (режим 600).\n" "$@" ;;
        uk-UA:msg_pg_pgdg_fallback) printf "PostgreSQL %s недоступний для цієї системи; замість нього встановлюється PostgreSQL з дистрибутива.\n" "$@" ;;
        uk-UA:msg_pg_distro_unsupported) printf "Дистрибутив не підтримується для автоматичного встановлення PostgreSQL: %s\n" "$@" ;;
        uk-UA:msg_pg_hba_warn) echo "Увага: не вдалося оновити pg_hba.conf; PostgreSQL може відхилити вхід панелі через TCP (автентифікація ident)." ;;
        uk-UA:msg_pg_cred_write_failed) printf "Не вдалося записати дані доступу PostgreSQL у %s\n" "$@" ;;
        uk-UA:msg_pg_client_tools) echo "Встановлення клієнтських інструментів PostgreSQL (pg_dump/pg_restore) для резервного копіювання з панелі..." ;;
        uk-UA:msg_acme_installing_ssl) echo "Встановлення acme.sh для керування SSL-сертифікатами..." ;;
        uk-UA:msg_acme_failed) echo "Не вдалося встановити acme.sh" ;;
        uk-UA:msg_acme_ok) echo "acme.sh успішно встановлено" ;;
        uk-UA:msg_ssl_setup_start) echo "Налаштування SSL-сертифіката..." ;;
        uk-UA:msg_acme_failed_skip) echo "Не вдалося встановити acme.sh, налаштування SSL пропущено" ;;
        uk-UA:msg_ssl_issuing_domain) printf "Випуск SSL-сертифіката для %s...\n" "$@" ;;
        uk-UA:msg_ssl_port80_note) echo "Примітка: порт 80 має бути відкритий і доступний з інтернету" ;;
        uk-UA:msg_ssl_issue_failed) printf "Не вдалося випустити сертифікат для %s\n" "$@" ;;
        uk-UA:msg_ssl_retry_hint) echo "Переконайтеся, що порт 80 відкритий, і повторіть пізніше за допомогою: easyxray" ;;
        uk-UA:msg_ssl_install_failed) echo "Не вдалося встановити сертифікат" ;;
        uk-UA:msg_ssl_installed) echo "SSL-сертифікат успішно встановлено та налаштовано!" ;;
        uk-UA:msg_cert_files_not_found) echo "Файли сертифіката не знайдено" ;;
        uk-UA:msg_ipcert_setup) echo "Налаштування IP-сертифіката Let's Encrypt (профіль shortlived)..." ;;
        uk-UA:msg_ipcert_validity_note) echo "Примітка: IP-сертифікати дійсні близько 6 днів і продовжуються автоматично." ;;
        uk-UA:msg_ipcert_port_note) echo "За замовчуванням використовується порт 80. Якщо ви виберете інший порт, переконайтеся, що зовнішній порт 80 перенаправляється на нього." ;;
        uk-UA:msg_ipv4_required) echo "Потрібна адреса IPv4" ;;
        uk-UA:msg_ipv4_invalid) printf "Неприпустима адреса IPv4: %s\n" "$@" ;;
        uk-UA:msg_ipv6_included) printf "Додається адреса IPv6: %s\n" "$@" ;;
        uk-UA:msg_acme_port_prompt) echo "Порт для слухача ACME HTTP-01 (за замовчуванням 80):" ;;
        uk-UA:msg_port_invalid_fallback) echo "Вказано неприпустимий порт. Використовується 80." ;;
        uk-UA:msg_port_using) printf "Порт %s використовується для окремої перевірки.\n" "$@" ;;
        uk-UA:msg_port_forward_note) printf "Нагадування: Let's Encrypt усе одно підключається до порту 80; перенаправте зовнішній порт 80 на %s.\n" "$@" ;;
        uk-UA:msg_port_in_use) printf "Порт %s зайнятий.\n" "$@" ;;
        uk-UA:msg_port_busy_ni) printf "Порт %s зайнятий; неможливо продовжити в неінтерактивному режимі.\n" "$@" ;;
        uk-UA:msg_acme_port_retry_prompt) echo "Введіть інший порт для автономного слухача acme.sh (залиште порожнім для скасування):" ;;
        uk-UA:msg_port_busy) printf "Порт %s зайнятий; неможливо продовжити.\n" "$@" ;;
        uk-UA:msg_port_invalid) echo "Вказано неприпустимий порт." ;;
        uk-UA:msg_port_free) printf "Порт %s вільний і готовий для окремої перевірки.\n" "$@" ;;
        uk-UA:msg_ipcert_issuing) printf "Випуск IP-сертифіката для %s...\n" "$@" ;;
        uk-UA:msg_ipcert_issue_failed) echo "Не вдалося випустити IP-сертифікат" ;;
        uk-UA:msg_ipcert_port_hint) printf "Переконайтеся, що порт %s доступний (або перенаправлений із зовнішнього порту 80)\n" "$@" ;;
        uk-UA:msg_cert_issued_installing) echo "Сертифікат успішно випущено, встановлення..." ;;
        uk-UA:msg_cert_files_missing) echo "Файли сертифіката не знайдено після встановлення" ;;
        uk-UA:msg_cert_files_installed) echo "Файли сертифіката успішно встановлено" ;;
        uk-UA:msg_cert_paths_setting) echo "Налаштування шляхів до сертифіката для панелі..." ;;
        uk-UA:msg_cert_files_at) echo "Файли сертифіката розміщено в:" ;;
        uk-UA:msg_cert_file) echo "Файл сертифіката:" ;;
        uk-UA:msg_cert_key) echo "Файл приватного ключа:" ;;
        uk-UA:msg_cert_paths_ok) echo "Шляхи до сертифікатів задано для панелі" ;;
        uk-UA:msg_ipcert_installed) echo "IP-сертифікат успішно встановлено та налаштовано!" ;;
        uk-UA:msg_ipcert_autorenew) echo "Сертифікат дійсний близько 6 днів, автоматично продовжується завданням cron acme.sh." ;;
        uk-UA:msg_acme_autorenew) echo "acme.sh автоматично продовжить сертифікат і перезавантажить easyxray до закінчення терміну дії." ;;
        uk-UA:msg_acme_installing) echo "Встановлення acme.sh..." ;;
        uk-UA:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain потребує коректний EASYXRAY_DOMAIN (отримано: '%s').\n" "$@" ;;
        uk-UA:msg_domain_prompt) echo "Введіть доменне ім'я: " ;;
        uk-UA:msg_domain_empty) echo "Доменне ім'я не може бути порожнім. Спробуйте ще раз." ;;
        uk-UA:msg_domain_invalid) echo "Невірний формат домену. Введіть коректне доменне ім'я." ;;
        uk-UA:msg_domain_checking) printf "Ваш домен: %s, виконується перевірка...\n" "$@" ;;
        uk-UA:msg_cert_existing_reuse) printf "Знайдено наявний сертифікат для %s, його буде використано повторно.\n" "$@" ;;
        uk-UA:msg_acme_state_incomplete) printf "Виявлено незавершений стан acme.sh для %s (немає дійсних файлів сертифіката); його буде очищено, і сертифікат випустять заново.\n" "$@" ;;
        uk-UA:msg_domain_ready) echo "Ваш домен готовий до випуску сертифікатів..." ;;
        uk-UA:msg_acme_port_choose_prompt) echo "Виберіть, який порт використовувати (за замовчуванням 80):" ;;
        uk-UA:msg_port_input_invalid) printf "Введене значення %s неприпустиме, буде використано типовий порт 80.\n" "$@" ;;
        uk-UA:msg_port_will_use) printf "Для випуску сертифікатів буде використано порт: %s. Переконайтеся, що він відкритий.\n" "$@" ;;
        uk-UA:msg_panel_stopping) echo "Панель тимчасово зупиняється..." ;;
        uk-UA:msg_cert_issue_failed_logs) echo "Не вдалося випустити сертифікат, перевірте логи." ;;
        uk-UA:msg_cert_issue_succeeded) echo "Сертифікат успішно випущено, встановлення сертифікатів..." ;;
        uk-UA:msg_cert_using_existing) echo "Використовується наявний сертифікат, встановлення сертифікатів..." ;;
        uk-UA:msg_reloadcmd_default) echo "Типове значення --reloadcmd для ACME:" ;;
        uk-UA:msg_reloadcmd_runs_on) echo "Ця команда виконуватиметься під час кожного випуску та продовження сертифіката." ;;
        uk-UA:msg_reloadcmd_modify_prompt) echo "Хочете змінити --reloadcmd для ACME? (y/n):" ;;
        uk-UA:msg_reloadcmd_preset) echo "Попередньо заданий варіант: systemctl reload nginx ; systemctl restart easyxray" ;;
        uk-UA:msg_reloadcmd_custom) echo "Введіть власну команду" ;;
        uk-UA:msg_reloadcmd_keep_default) echo "Залишити reloadcmd за замовчуванням" ;;
        uk-UA:msg_reloadcmd_option_prompt) echo "Виберіть варіант:" ;;
        uk-UA:msg_reloadcmd_is_preset) echo "Reloadcmd: systemctl reload nginx ; systemctl restart easyxray" ;;
        uk-UA:msg_reloadcmd_order) echo "Рекомендується ставити перезапуск easyxray у кінці" ;;
        uk-UA:msg_reloadcmd_custom_prompt) echo "Введіть власну команду reloadcmd:" ;;
        uk-UA:msg_reloadcmd_is) printf "Reloadcmd: %s\n" "$@" ;;
        uk-UA:msg_reloadcmd_keeping) echo "Зберігається reloadcmd за замовчуванням" ;;
        uk-UA:msg_cert_installed_autorenew) echo "Сертифікат успішно встановлено, вмикається автооновлення..." ;;
        uk-UA:msg_cert_install_failed_exit) echo "Не вдалося встановити сертифікат, вихід." ;;
        uk-UA:msg_autorenew_issues) echo "Під час налаштування автооновлення виникли проблеми, відомості про сертифікат:" ;;
        uk-UA:msg_autorenew_ok) echo "Автооновлення виконано успішно, відомості про сертифікат:" ;;
        uk-UA:msg_cert_set_panel_prompt) echo "Призначити цей сертифікат для панелі? (y/n):" ;;
        uk-UA:msg_done_url) echo "URL доступу:" ;;
        uk-UA:msg_cert_restart) echo "Панель перезапуститься, щоб застосувати SSL-сертифікат..." ;;
        uk-UA:msg_cert_rejected) echo "Помилка: панель відхилила сертифікат, тому панель працювала б через простий HTTP." ;;
        uk-UA:msg_skip_panel_path) echo "Налаштування шляху панелі пропущено." ;;
        uk-UA:msg_ssl_choose) echo "Виберіть спосіб налаштування SSL-сертифіката:" ;;
        uk-UA:msg_ssl_opt1) echo "Let's Encrypt для домену (термін 90 днів, автооновлення)" ;;
        uk-UA:msg_ssl_opt2) echo "Let's Encrypt для IP-адреси (термін 6 днів, автооновлення)" ;;
        uk-UA:msg_ssl_opt3) echo "Власний SSL-сертифікат (шлях до наявних файлів)" ;;
        uk-UA:msg_ssl_opt4) echo "Пропустити SSL (для досвідчених — лише за зворотним проксі або SSH-тунелем)" ;;
        uk-UA:msg_ssl_note_opts) echo "Примітка: для варіантів 1 і 2 потрібен відкритий порт 80. Для варіанта 3 потрібно вказати шляхи вручну." ;;
        uk-UA:msg_ssl_note_opt4) echo "Примітка: варіант 4 віддає панель звичайним HTTP - це безпечно лише за nginx/Caddy або через SSH-тунель." ;;
        uk-UA:msg_ssl_mode_unknown) printf "Невідоме значення EASYXRAY_SSL_MODE='%s', використовується none (HTTP).\n" "$@" ;;
        uk-UA:msg_ssl_pick) echo "Виберіть варіант (типово 2 для IP): " ;;
        uk-UA:msg_ssl_le_domain) echo "Використовується Let's Encrypt для сертифіката домену..." ;;
        uk-UA:msg_ssl_domain_ok) printf "✓ SSL-сертифікат успішно налаштовано для домену: %s\n" "$@" ;;
        uk-UA:msg_ssl_domain_extract_failed) echo "Налаштування SSL, імовірно, завершено, але не вдалося визначити домен" ;;
        uk-UA:msg_ssl_domain_failed) echo "Не вдалося налаштувати SSL-сертифікат для режиму домену." ;;
        uk-UA:msg_ssl_le_ip) echo "Використовується Let's Encrypt для IP-сертифіката (профіль shortlived)..." ;;
        uk-UA:msg_ipv4_confirm_prompt) printf "%s — це правильна вхідна публічна адреса IPv4 цього сервера? [Default y]:\n" "$@" ;;
        uk-UA:msg_ipv4_prompt) echo "Введіть публічну адресу IPv4 вашого сервера:" ;;
        uk-UA:msg_ipv4_invalid_retry) echo "Неприпустима адреса IPv4. Спробуйте ще раз." ;;
        uk-UA:msg_ipv6_prompt) echo "Чи є адреса IPv6, яку потрібно додати? (залиште порожнім, щоб пропустити):" ;;
        uk-UA:msg_ipcert_configured) echo "✓ IP-сертифікат Let's Encrypt успішно налаштовано" ;;
        uk-UA:msg_ipcert_setup_failed) echo "✗ Не вдалося налаштувати IP-сертифікат. Перевірте, що порт 80 відкритий." ;;
        uk-UA:msg_custom_cert_using) echo "Використовується власний наявний сертифікат..." ;;
        uk-UA:msg_custom_cert_domain_prompt) echo "Введіть доменне ім'я, для якого випущено сертифікат:" ;;
        uk-UA:msg_custom_cert_path_prompt) echo "Введіть шлях до сертифіката (ключові слова: .crt / fullchain):" ;;
        uk-UA:msg_file_missing) echo "Помилка: файл не існує! Спробуйте ще раз." ;;
        uk-UA:msg_file_unreadable) echo "Помилка: файл існує, але недоступний для читання (перевірте права)!" ;;
        uk-UA:msg_file_empty) echo "Помилка: файл порожній!" ;;
        uk-UA:msg_custom_key_path_prompt) echo "Введіть шлях до закритого ключа (ключові слова: .key / privatekey):" ;;
        uk-UA:msg_custom_cert_not_applied) echo "✗ Власний сертифікат не застосовано -- панель працювала б звичайним HTTP." ;;
        uk-UA:msg_custom_cert_applied) echo "✓ Шляхи до власного сертифіката застосовано." ;;
        uk-UA:msg_custom_cert_renew_note) echo "Примітка: ви самостійно відповідаєте за продовження цих файлів ззовні." ;;
        uk-UA:msg_no_ssl_title) echo "⚠ Панель буде встановлено БЕЗ SSL/TLS." ;;
        uk-UA:msg_no_ssl_plaintext) echo "Дані для входу та cookie передаватимуться звичайним HTTP." ;;
        uk-UA:msg_no_ssl_safe_when) echo "Безпечно лише якщо:" ;;
        uk-UA:msg_no_ssl_proxy) echo "  • Зворотний проксі (nginx, Caddy, Traefik) завершує TLS за вас, або" ;;
        uk-UA:msg_no_ssl_tunnel) echo "  • Ви звертаєтеся до панелі виключно через SSH-тунель" ;;
        uk-UA:msg_bind_localhost_prompt) echo "Прив'язати панель лише до 127.0.0.1? (рекомендовано — доступ лише через SSH-тунель або зворотний проксі) [y/N]:" ;;
        uk-UA:msg_panel_localhost_only) echo "✓ Панель прив'язано лише до 127.0.0.1. Тепер вона недоступна з публічного інтернету." ;;
        uk-UA:msg_ssh_forward_title) echo "Переадресація портів SSH — відкривайте панель з локальної машини через:" ;;
        uk-UA:msg_ssh_cmd_standard) echo "  Стандартна команда SSH:" ;;
        uk-UA:msg_ssh_cmd_key) echo "  Якщо використовується SSH-ключ:" ;;
        uk-UA:msg_ssh_cmd_open) echo "  Потім відкрийте у браузері:" ;;
        uk-UA:msg_ssh_alt_proxy) printf "Альтернатива: спрямуйте зворотний проксі (nginx/Caddy) на 127.0.0.1:%s і дозвольте йому завершувати TLS.\n" "$@" ;;
        uk-UA:msg_no_ssl_all_interfaces) echo "Панель слухатиме всі інтерфейси звичайним HTTP. Переконайтеся, що перед нею TLS завершує щось інше." ;;
        uk-UA:msg_ssl_skipped) echo "✓ Налаштування SSL пропущено." ;;
        uk-UA:msg_ssl_option_invalid) echo "Неприпустимий варіант. Налаштування SSL пропускається." ;;
        uk-UA:msg_ip_detect_failed) echo "Не вдалося автоматично визначити IP сервера в жодного провайдера." ;;
        uk-UA:msg_db_selection_title) echo "Вибір бази даних" ;;
        uk-UA:msg_db_opt_sqlite) echo "1) SQLite     (за замовчуванням — рекомендовано для < 500 клієнтів)" ;;
        uk-UA:msg_db_opt_pg) echo "2) PostgreSQL (рекомендовано для великої кількості клієнтів / багатьох вузлів)" ;;
        uk-UA:msg_choose_default) echo "Виберіть [1]:" ;;
        uk-UA:msg_db_label_pg_external) echo "PostgreSQL (зовнішній)" ;;
        uk-UA:msg_pg_installing_local) echo "Локальне встановлення PostgreSQL (неінтерактивний режим)..." ;;
        uk-UA:msg_pg_failed_ni) echo "Встановлення PostgreSQL не вдалося в неінтерактивному режимі; встановлення перервано." ;;
        uk-UA:msg_pg_env_hint) echo "Задайте EASYXRAY_DB_DSN, щоб використати наявний сервер, або EASYXRAY_DB_TYPE=sqlite." ;;
        uk-UA:msg_pg_menu_local) echo "1) Встановити PostgreSQL локально та створити окремого користувача й базу даних (рекомендовано)" ;;
        uk-UA:msg_pg_menu_external) echo "2) Використати наявний сервер PostgreSQL (введіть DSN)" ;;
        uk-UA:msg_pg_dsn_prompt) echo "Введіть DSN PostgreSQL (postgres://user:pass@host:port/dbname?sslmode=disable):" ;;
        uk-UA:msg_pg_installing) echo "Встановлення PostgreSQL — це може зайняти певний час..." ;;
        uk-UA:msg_pg_credfile_failed) echo "Не вдалося створити тимчасовий файл даних доступу." ;;
        uk-UA:msg_pg_failed) echo "Встановлення PostgreSQL не вдалося." ;;
        uk-UA:msg_pg_menu_retry) echo "1) Повторити локальне встановлення" ;;
        uk-UA:msg_pg_menu_dsn) echo "2) Ввести зовнішній DSN" ;;
        uk-UA:msg_pg_menu_abort) echo "3) Перервати встановлення" ;;
        uk-UA:msg_pg_menu_fallback) echo "4) Перейти на SQLite" ;;
        uk-UA:msg_install_aborted) echo "Встановлення перервано." ;;
        uk-UA:msg_pg_client_missing) echo "⚠ Не вдалося встановити pg_dump/pg_restore. Резервне копіювання та відновлення бази даних у панелі будуть недоступні, доки ви не встановите пакет postgresql-client." ;;
        uk-UA:msg_panel_port) printf "Порт вашої панелі: %s\n" "$@" ;;
        uk-UA:msg_panel_port_random) printf "Згенеровано випадковий порт: %s\n" "$@" ;;
        uk-UA:msg_panel_port_customize_prompt) echo "Налаштувати порт панелі? (Якщо ні, буде застосовано випадковий порт) [y/n]:" ;;
        uk-UA:msg_panel_port_prompt) echo "Укажіть порт панелі:" ;;
        uk-UA:msg_ssl_title) echo "Налаштування SSL-сертифіката (РЕКОМЕНДОВАНО)" ;;
        uk-UA:msg_ssl_recommend) echo "SSL наполегливо рекомендується. Пропускайте, лише якщо зворотний проксі або SSH-тунель забезпечує TLS." ;;
        uk-UA:msg_ssl_le_note) echo "Let's Encrypt тепер підтримує і домени, і IP-адреси!" ;;
        uk-UA:msg_abort1) echo "Сертифікат не вдалося застосувати до панелі, тому вона працювала б через простий HTTP за URL з https://." ;;
        uk-UA:msg_abort2) echo "Більше нічого не змінено; виправте сертифікат і запустіть інсталятор знову." ;;
        uk-UA:msg_done_title) echo "Встановлення панелі завершено!" ;;
        uk-UA:msg_done_user) echo "Ім'я користувача:" ;;
        uk-UA:msg_done_pass) echo "Пароль:" ;;
        uk-UA:msg_done_port) echo "Порт:" ;;
        uk-UA:msg_done_wbp) echo "Шлях WebBasePath:" ;;
        uk-UA:msg_done_db) echo "База даних:" ;;
        uk-UA:msg_done_token) echo "API-токен:" ;;
        uk-UA:msg_done_save) echo "ВАЖЛИВО: збережіть ці дані в надійному місці!" ;;
        uk-UA:msg_ssl_on) echo "SSL-сертифікат: увімкнено та налаштовано" ;;
        uk-UA:msg_ssl_off) echo "SSL-сертифікат: пропущено — панель лише через HTTP. Використовуйте зворотний проксі або SSH-тунель." ;;
        uk-UA:msg_pg_backup_title) echo "Резервне копіювання та відновлення PostgreSQL вбудовано в панель:" ;;
        uk-UA:msg_pg_backup_menu) echo "→ Резервне копіювання та відновлення" ;;
        uk-UA:msg_pg_backup_note) echo "  «Резервна копія» завантажує файл .dump від pg_dump; «Відновлення» завантажує його назад через pg_restore." ;;
        uk-UA:msg_pg_creds_title) echo "Дані доступу PostgreSQL" ;;
        uk-UA:msg_pg_db_name) echo "Ім'я бази даних:" ;;
        uk-UA:msg_pg_username) echo "Ім'я користувача:" ;;
        uk-UA:msg_pg_password) echo "Пароль:" ;;
        uk-UA:msg_pg_host) echo "Хост:" ;;
        uk-UA:msg_pg_port) echo "Порт:" ;;
        uk-UA:msg_pg_dsn) echo "DSN:" ;;
        uk-UA:msg_pg_env_file) echo "Файл оточення:" ;;
        uk-UA:msg_pg_connect) echo "Підключення з цього сервера:" ;;
        uk-UA:msg_pg_as_superuser) echo "(від імені суперкористувача postgres)" ;;
        uk-UA:msg_pg_env_read) printf "⚠ Панель читає ці дані доступу з %s.\n" "$@" ;;
        uk-UA:msg_pg_save_password) echo "⚠ Збережіть пароль — в іншому місці він не зберігається у відкритому вигляді." ;;
        uk-UA:msg_wbp_generating) echo "WebBasePath відсутній або занадто короткий. Створюється новий..." ;;
        uk-UA:msg_wbp_new) printf "Новий WebBasePath: %s\n" "$@" ;;
        uk-UA:msg_default_creds) echo "Виявлено дані доступу за замовчуванням. Потрібне оновлення безпеки..." ;;
        uk-UA:msg_new_creds) echo "Згенеровано нові випадкові дані для входу:" ;;
        uk-UA:msg_creds_set) echo "Ім'я користувача, пароль і WebBasePath задано правильно." ;;
        uk-UA:msg_ssl_already_configured) echo "SSL-сертифікат уже налаштовано. Дій не потрібно." ;;
        uk-UA:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s, автоматичне налаштування Fail2ban пропускається.\n" "$@" ;;
        uk-UA:msg_f2b_skipped_cli) echo "CLI easyxray не знайдено; автоматичне налаштування Fail2ban пропускається." ;;
        uk-UA:msg_f2b_skipped_old) echo "Цей easyxray.sh старіший за команду 'easyxray setup-fail2ban'; автоматичне налаштування Fail2ban пропускається." ;;
        uk-UA:msg_f2b_setup) echo "Налаштування Fail2ban для функції обмеження за IP..." ;;
        uk-UA:msg_f2b_done) echo "Налаштування Fail2ban завершено." ;;
        uk-UA:msg_f2b_incomplete) echo "Налаштування Fail2ban не завершено; обмеження за IP залишається вимкненим, доки ви не запустите 'easyxray' і не відкриєте меню обмеження за IP. Продовження." ;;
        uk-UA:msg_systemd_hardening_note) printf "Примітка: systemd %s ігнорує частину налаштувань захисту в easyxray.service; панель усе одно запуститься.\n" "$@" ;;
        uk-UA:msg_systemd_hardening_missing) printf "      Не застосовано, потрібен новіший systemd: %s.\n" "$@" ;;
        uk-UA:msg_systemd_hardening_alias) echo "      Папки панелі залишаються доступними для запису завдяки ReadWriteDirectories=, псевдоніму, який встановлює цей скрипт." ;;
        uk-UA:msg_systemd_hardening_rest) echo "      Решта налаштувань захисту діють. Оновіть systemd, щоб застосувати зазначене вище." ;;
        uk-UA:msg_ws_warn_head) echo "Увага: ці папки містять пробіли й були виключені з" ;;
        uk-UA:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf: %s\n" "$@" ;;
        uk-UA:msg_ws_warn_tail) echo "         Панель не може записувати до них через sandbox юніта." ;;
        uk-UA:msg_sandbox_refresh_failed) printf "Увага: не вдалося оновити %s/easyxray.service.d/10-easyxray-sandbox.conf.\n" "$@" ;;
        uk-UA:msg_sandbox_write_hint) echo "Якщо EASYXRAY_DB_FOLDER або EASYXRAY_LOG_FOLDER вказують за межі /etc/easyxray і /var/log/easyxray, панель може не мати змоги записувати до них за ProtectSystem=full." ;;
        uk-UA:msg_checksum_none) echo "Для цього релізу не опубліковано контрольну суму, перевірку пропущено" ;;
        uk-UA:msg_checksum_download_failed) printf "Не вдалося завантажити контрольну суму для %s (HTTP %s)\n" "$@" ;;
        uk-UA:msg_checksum_mismatch) printf "Невідповідність контрольної суми для %s: очікувалося %s, отримано %s\n" "$@" ;;
        uk-UA:msg_checksum_ok) printf "Контрольну суму перевірено: %s\n" "$@" ;;
        uk-UA:msg_repo_file_missing) printf "%s недоступний для %s (HTTP %s)\n" "$@" ;;
        uk-UA:msg_repo_file_missing_hint) echo "Встановіть реліз, який його містить, або 'dev' для рухомої збірки. Ваше наявне встановлення не змінено." ;;
        uk-UA:msg_version_fetch_failed) echo "Не вдалося отримати версію easyxray, можливо, через обмеження GitHub API, спробуйте пізніше" ;;
        uk-UA:msg_latest_version) printf "Отримано останню версію easyxray: %s, починається встановлення...\n" "$@" ;;
        uk-UA:msg_download_failed) echo "Не вдалося завантажити easyxray, переконайтеся, що ваш сервер має доступ до GitHub" ;;
        uk-UA:msg_archive_empty) echo "Завантажений архів релізу easyxray порожній" ;;
        uk-UA:msg_dev_build) echo "Встановлюється рухома збірка dev (тег: dev-latest). Це передреліз для кожного коміту, а не стабільна версія." ;;
        uk-UA:msg_install_start) echo "Початок встановлення" ;;
        uk-UA:msg_download_version_failed) printf "Не вдалося завантажити easyxray %s, перевірте, чи існує ця версія\n" "$@" ;;
        uk-UA:msg_script_download_failed) echo "Не вдалося завантажити easyxray.sh" ;;
        uk-UA:msg_script_empty) echo "Завантажений easyxray.sh порожній" ;;
        uk-UA:msg_bin_backup_failed) echo "Не вдалося створити резервну копію bin/ -- власні файли там не збережуться під час цього оновлення" ;;
        uk-UA:msg_extract_failed) echo "Не вдалося розпакувати архів релізу easyxray -- попереднє встановлення вже видалено, тому панель не запуститься, доки це не буде виправлено; спробуйте запустити інсталятор ще раз" ;;
        uk-UA:msg_binary_missing) echo "У розпакованому архіві easyxray відсутній виконуваний файл easyxray -- попереднє встановлення вже видалено, тому панель не запуститься, доки це не буде виправлено; спробуйте запустити інсталятор ще раз" ;;
        uk-UA:msg_bin_restored) printf "Відновлено власні файли в bin/, які не постачаються з цим релізом: %s\n" "$@" ;;
        uk-UA:msg_script_install_failed) echo "Не вдалося встановити easyxray.sh" ;;
        uk-UA:msg_gitignore_added) echo "EasyXray.db додано до /etc/.gitignore для etckeeper" ;;
        uk-UA:msg_gitignore_created) echo "Створено /etc/.gitignore і додано EasyXray.db для etckeeper" ;;
        uk-UA:msg_rc_download_failed) echo "Не вдалося завантажити easyxray.rc" ;;
        uk-UA:msg_rc_empty) echo "Завантажений easyxray.rc порожній" ;;
        uk-UA:msg_rc_install_failed) echo "Не вдалося встановити easyxray.rc" ;;
        uk-UA:msg_service_found) echo "Знайдено easyxray.service у розпакованих файлах, встановлення..." ;;
        uk-UA:msg_service_found_variant) printf "Знайдено easyxray.service.%s у розпакованих файлах, встановлення...\n" "$@" ;;
        uk-UA:msg_service_downloading) echo "Файли служби не знайдено в tar.gz, завантаження з GitHub..." ;;
        uk-UA:msg_service_install_failed) printf "Не вдалося встановити easyxray.service з GitHub (%s) -- архів релізу також його не містив\n" "$@" ;;
        uk-UA:msg_systemd_setup) echo "Налаштування юніта systemd..." ;;
        uk-UA:msg_service_file_failed) echo "Не вдалося встановити файл easyxray.service" ;;
        uk-UA:msg_installed_ok) echo "встановлення завершено, панель уже працює..." ;;
        uk-UA:msg_running) echo "Виконується..." ;;
        uk-UA:msg_menu_admin) echo "Скрипт адміністрування" ;;
        uk-UA:msg_menu_start) echo "Запустити" ;;
        uk-UA:msg_menu_stop) echo "Зупинити" ;;
        uk-UA:msg_menu_restart) echo "Перезапустити" ;;
        uk-UA:msg_menu_status) echo "Поточний статус" ;;
        uk-UA:msg_menu_settings) echo "Поточні налаштування" ;;
        uk-UA:msg_menu_enable) echo "Увімкнути автозапуск при завантаженні системи" ;;
        uk-UA:msg_menu_disable) echo "Вимкнути автозапуск при завантаженні системи" ;;
        uk-UA:msg_menu_log) echo "Переглянути логи" ;;
        uk-UA:msg_menu_banlog) echo "Переглянути логи блокувань Fail2ban" ;;
        uk-UA:msg_menu_update) echo "Оновити" ;;
        uk-UA:msg_menu_legacy) echo "Застаріла версія" ;;
        uk-UA:msg_menu_install) echo "Встановити" ;;
        uk-UA:msg_menu_uninstall) echo "Видалити" ;;
        # ---- tr-TR ----
        tr-TR:msg_lang_menu_title) echo "Kurulum dilini seçin:" ;;
        tr-TR:msg_lang_invalid) echo "Geçersiz seçim, mevcut dil ile devam ediliyor." ;;
        tr-TR:msg_root_required) echo "Kritik hata: Bu betiği root yetkisiyle çalıştırın" ;;
        tr-TR:msg_menu_title) echo "easyxray denetim menüsü kullanımları (alt komutlar):" ;;
        tr-TR:msg_unsupported_arch) echo "Desteklenmeyen CPU mimarisi." ;;
        tr-TR:msg_arch) printf "Mimari: %s\n" "$@" ;;
        tr-TR:msg_os_check_failed) echo "Sistem işletim sistemi kontrol edilemedi, lütfen yazarla iletişime geçin!" ;;
        tr-TR:msg_os_release) printf "İşletim sistemi sürümü şudur: %s\n" "$@" ;;
        tr-TR:msg_cert_not_pem) echo "Sertifika veya özel anahtar okunabilir bir PEM dosyası değil" ;;
        tr-TR:msg_cert_key_mismatch) echo "Özel anahtar sertifikayla eşleşmiyor" ;;
        tr-TR:msg_cert_file_unreadable) printf "Sertifika dosyası eksik, boş veya okunamıyor: %s\n" "$@" ;;
        tr-TR:msg_cert_key_unreadable) printf "Özel anahtar dosyası eksik, boş veya okunamıyor: %s\n" "$@" ;;
        tr-TR:msg_cert_cli_failed) printf "easyxray cert %s koduyla çıktı: %s\n" "$@" ;;
        tr-TR:msg_cert_not_saved) printf "Panel sertifikayı kaydetmedi (kayıtlı cert=%s, key=%s)\n" "$@" ;;
        tr-TR:msg_result_write_failed) printf "Uyarı: %s yazılamadı.\n" "$@" ;;
        tr-TR:msg_result_written) printf "Kurulum sonucu %s dosyasına yazıldı (mod 600).\n" "$@" ;;
        tr-TR:msg_pg_pgdg_fallback) printf "PostgreSQL %s bu sistem için mevcut değil; bunun yerine dağıtımın PostgreSQL sürümü kuruluyor.\n" "$@" ;;
        tr-TR:msg_pg_distro_unsupported) printf "Otomatik PostgreSQL kurulumu için desteklenmeyen dağıtım: %s\n" "$@" ;;
        tr-TR:msg_pg_hba_warn) echo "Uyarı: pg_hba.conf güncellenemedi; PostgreSQL panelin TCP girişini reddedebilir (ident kimlik doğrulaması)." ;;
        tr-TR:msg_pg_cred_write_failed) printf "PostgreSQL kimlik bilgileri %s dosyasına yazılamadı\n" "$@" ;;
        tr-TR:msg_pg_client_tools) echo "Panel içi yedekleme için PostgreSQL istemci araçları (pg_dump/pg_restore) kuruluyor..." ;;
        tr-TR:msg_acme_installing_ssl) echo "SSL sertifika yönetimi için acme.sh kuruluyor..." ;;
        tr-TR:msg_acme_failed) echo "acme.sh kurulamadı" ;;
        tr-TR:msg_acme_ok) echo "acme.sh başarıyla kuruldu" ;;
        tr-TR:msg_ssl_setup_start) echo "SSL sertifikası ayarlanıyor..." ;;
        tr-TR:msg_acme_failed_skip) echo "acme.sh kurulamadı, SSL kurulumu atlanıyor" ;;
        tr-TR:msg_ssl_issuing_domain) printf "%s için SSL sertifikası düzenleniyor...\n" "$@" ;;
        tr-TR:msg_ssl_port80_note) echo "Not: 80 numaralı bağlantı noktası açık olmalı ve internetten erişilebilmelidir" ;;
        tr-TR:msg_ssl_issue_failed) printf "%s için sertifika düzenlenemedi\n" "$@" ;;
        tr-TR:msg_ssl_retry_hint) echo "Lütfen 80 numaralı bağlantı noktasının açık olduğundan emin olun ve daha sonra şu komutla tekrar deneyin: easyxray" ;;
        tr-TR:msg_ssl_install_failed) echo "Sertifika kurulamadı" ;;
        tr-TR:msg_ssl_installed) echo "SSL sertifikası başarıyla kuruldu ve yapılandırıldı!" ;;
        tr-TR:msg_cert_files_not_found) echo "Sertifika dosyaları bulunamadı" ;;
        tr-TR:msg_ipcert_setup) echo "Let's Encrypt IP sertifikası ayarlanıyor (shortlived profili)..." ;;
        tr-TR:msg_ipcert_validity_note) echo "Not: IP sertifikaları yaklaşık 6 gün geçerlidir ve otomatik yenilenir." ;;
        tr-TR:msg_ipcert_port_note) echo "Varsayılan dinleyici 80 numaralı bağlantı noktasıdır. Başka bir bağlantı noktası seçerseniz, harici 80 numaralı bağlantı noktasının ona yönlendirildiğinden emin olun." ;;
        tr-TR:msg_ipv4_required) echo "IPv4 adresi gerekli" ;;
        tr-TR:msg_ipv4_invalid) printf "Geçersiz IPv4 adresi: %s\n" "$@" ;;
        tr-TR:msg_ipv6_included) printf "IPv6 adresi dahil ediliyor: %s\n" "$@" ;;
        tr-TR:msg_acme_port_prompt) echo "ACME HTTP-01 dinleyicisi için kullanılacak bağlantı noktası (varsayılan 80):" ;;
        tr-TR:msg_port_invalid_fallback) echo "Geçersiz bağlantı noktası girildi. 80 değerine dönülüyor." ;;
        tr-TR:msg_port_using) printf "Bağımsız doğrulama için %s bağlantı noktası kullanılıyor.\n" "$@" ;;
        tr-TR:msg_port_forward_note) printf "Hatırlatma: Let's Encrypt yine 80 numaralı bağlantı noktasına bağlanır; harici 80 numaralı bağlantı noktasını %s adresine yönlendirin.\n" "$@" ;;
        tr-TR:msg_port_in_use) printf "%s bağlantı noktası kullanımda.\n" "$@" ;;
        tr-TR:msg_port_busy_ni) printf "%s bağlantı noktası meşgul; etkileşimsiz kipte devam edilemez.\n" "$@" ;;
        tr-TR:msg_acme_port_retry_prompt) echo "acme.sh bağımsız dinleyicisi için başka bir bağlantı noktası girin (iptal etmek için boş bırakın):" ;;
        tr-TR:msg_port_busy) printf "%s bağlantı noktası meşgul; devam edilemez.\n" "$@" ;;
        tr-TR:msg_port_invalid) echo "Geçersiz bağlantı noktası girildi." ;;
        tr-TR:msg_port_free) printf "%s bağlantı noktası boş ve bağımsız doğrulamaya hazır.\n" "$@" ;;
        tr-TR:msg_ipcert_issuing) printf "%s için IP sertifikası düzenleniyor...\n" "$@" ;;
        tr-TR:msg_ipcert_issue_failed) echo "IP sertifikası düzenlenemedi" ;;
        tr-TR:msg_ipcert_port_hint) printf "Lütfen %s bağlantı noktasına erişilebildiğinden emin olun (veya harici 80 numaralı bağlantı noktasından yönlendirildiğinden)\n" "$@" ;;
        tr-TR:msg_cert_issued_installing) echo "Sertifika başarıyla düzenlendi, kuruluyor..." ;;
        tr-TR:msg_cert_files_missing) echo "Kurulumdan sonra sertifika dosyaları bulunamadı" ;;
        tr-TR:msg_cert_files_installed) echo "Sertifika dosyaları başarıyla kuruldu" ;;
        tr-TR:msg_cert_paths_setting) echo "Panel için sertifika yolları ayarlanıyor..." ;;
        tr-TR:msg_cert_files_at) echo "Sertifika dosyaları şu konumda:" ;;
        tr-TR:msg_cert_file) echo "Sertifika Dosyası:" ;;
        tr-TR:msg_cert_key) echo "Özel Anahtar Dosyası:" ;;
        tr-TR:msg_cert_paths_ok) echo "Sertifika yolları panel için ayarlandı" ;;
        tr-TR:msg_ipcert_installed) echo "IP sertifikası başarıyla kuruldu ve yapılandırıldı!" ;;
        tr-TR:msg_ipcert_autorenew) echo "Sertifika yaklaşık 6 gün geçerlidir, acme.sh cron göreviyle otomatik yenilenir." ;;
        tr-TR:msg_acme_autorenew) echo "acme.sh, süresi dolmadan önce easyxray hizmetini otomatik yeniler ve yeniden yükler." ;;
        tr-TR:msg_acme_installing) echo "acme.sh kuruluyor..." ;;
        tr-TR:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain geçerli bir EASYXRAY_DOMAIN gerektirir (alınan: '%s').\n" "$@" ;;
        tr-TR:msg_domain_prompt) echo "Lütfen alan adınızı girin: " ;;
        tr-TR:msg_domain_empty) echo "Alan adı boş olamaz. Lütfen tekrar deneyin." ;;
        tr-TR:msg_domain_invalid) echo "Geçersiz alan adı biçimi. Lütfen geçerli bir alan adı girin." ;;
        tr-TR:msg_domain_checking) printf "Alan adınız: %s, kontrol ediliyor...\n" "$@" ;;
        tr-TR:msg_cert_existing_reuse) printf "%s için mevcut sertifika bulundu, yeniden kullanılacak.\n" "$@" ;;
        tr-TR:msg_acme_state_incomplete) printf "%s için eksik acme.sh durumu bulundu (geçerli sertifika dosyası yok); temizleniyor ve yeniden düzenleniyor.\n" "$@" ;;
        tr-TR:msg_domain_ready) echo "Alan adınız artık sertifika düzenlemeye hazır..." ;;
        tr-TR:msg_acme_port_choose_prompt) echo "Lütfen kullanılacak bağlantı noktasını seçin (varsayılan 80):" ;;
        tr-TR:msg_port_input_invalid) printf "Girdiniz %s geçersiz, varsayılan 80 numaralı bağlantı noktası kullanılacak.\n" "$@" ;;
        tr-TR:msg_port_will_use) printf "Sertifika düzenlemek için %s bağlantı noktası kullanılacak. Lütfen bu bağlantı noktasının açık olduğundan emin olun.\n" "$@" ;;
        tr-TR:msg_panel_stopping) echo "Panel geçici olarak durduruluyor..." ;;
        tr-TR:msg_cert_issue_failed_logs) echo "Sertifika düzenleme başarısız oldu, lütfen günlükleri kontrol edin." ;;
        tr-TR:msg_cert_issue_succeeded) echo "Sertifika düzenleme başarılı, sertifikalar kuruluyor..." ;;
        tr-TR:msg_cert_using_existing) echo "Mevcut sertifika kullanılıyor, sertifikalar kuruluyor..." ;;
        tr-TR:msg_reloadcmd_default) echo "ACME için varsayılan --reloadcmd şudur:" ;;
        tr-TR:msg_reloadcmd_runs_on) echo "Bu komut her sertifika düzenleme ve yenilemede çalışır." ;;
        tr-TR:msg_reloadcmd_modify_prompt) echo "ACME için --reloadcmd değerini değiştirmek ister misiniz? (y/n):" ;;
        tr-TR:msg_reloadcmd_preset) echo "Hazır ayar: systemctl reload nginx ; systemctl restart easyxray" ;;
        tr-TR:msg_reloadcmd_custom) echo "Kendi komutunuzu girin" ;;
        tr-TR:msg_reloadcmd_keep_default) echo "Varsayılan reloadcmd korunsun" ;;
        tr-TR:msg_reloadcmd_option_prompt) echo "Bir seçenek seçin:" ;;
        tr-TR:msg_reloadcmd_is_preset) echo "Reloadcmd: systemctl reload nginx ; systemctl restart easyxray" ;;
        tr-TR:msg_reloadcmd_order) echo "easyxray yeniden başlatmasının en sona konması önerilir" ;;
        tr-TR:msg_reloadcmd_custom_prompt) echo "Lütfen özel reloadcmd değerinizi girin:" ;;
        tr-TR:msg_reloadcmd_is) printf "Reloadcmd: %s\n" "$@" ;;
        tr-TR:msg_reloadcmd_keeping) echo "Varsayılan reloadcmd korunuyor" ;;
        tr-TR:msg_cert_installed_autorenew) echo "Sertifika kurulumu başarılı, otomatik yenileme etkinleştiriliyor..." ;;
        tr-TR:msg_cert_install_failed_exit) echo "Sertifika kurulumu başarısız oldu, çıkılıyor." ;;
        tr-TR:msg_autorenew_issues) echo "Otomatik yenileme kurulumunda sorunlar oluştu, sertifika ayrıntıları:" ;;
        tr-TR:msg_autorenew_ok) echo "Otomatik yenileme başarılı, sertifika ayrıntıları:" ;;
        tr-TR:msg_cert_set_panel_prompt) echo "Bu sertifikayı panel için ayarlamak ister misiniz? (y/n):" ;;
        tr-TR:msg_done_url) echo "Erişim URL'si:" ;;
        tr-TR:msg_cert_restart) echo "SSL sertifikasını uygulamak için panel yeniden başlatılacak..." ;;
        tr-TR:msg_cert_rejected) echo "Hata: panel sertifikayı reddetti, bu yüzden düz HTTP sunardı." ;;
        tr-TR:msg_skip_panel_path) echo "Panel yol ayarı atlanıyor." ;;
        tr-TR:msg_ssl_choose) echo "SSL sertifika kurulum yöntemini seçin:" ;;
        tr-TR:msg_ssl_opt1) echo "Alan Adı için Let's Encrypt (90 gün geçerli, otomatik yenilenir)" ;;
        tr-TR:msg_ssl_opt2) echo "IP Adresi için Let's Encrypt (6 gün geçerli, otomatik yenilenir)" ;;
        tr-TR:msg_ssl_opt3) echo "Özel SSL Sertifikası (Mevcut dosyaların Yolu)" ;;
        tr-TR:msg_ssl_opt4) echo "SSL'yi atla (gelişmiş: yalnızca ters proxy / SSH tüneli arkasında)" ;;
        tr-TR:msg_ssl_note_opts) echo "Not: 1 ve 2 numaralı seçenekler 80 numaralı bağlantı noktasının açık olmasını gerektirir. 3 numaralı seçenek elle girilen yollar gerektirir." ;;
        tr-TR:msg_ssl_note_opt4) echo "Not: 4 numaralı seçenek paneli düz HTTP üzerinden sunar - yalnızca nginx/Caddy arkasında veya bir SSH tüneli üzerinden güvenlidir." ;;
        tr-TR:msg_ssl_mode_unknown) printf "Bilinmeyen EASYXRAY_SSL_MODE='%s', varsayılan olarak none (HTTP) kullanılıyor.\n" "$@" ;;
        tr-TR:msg_ssl_pick) echo "Bir seçenek girin (IP için varsayılan 2): " ;;
        tr-TR:msg_ssl_le_domain) echo "Alan adı sertifikası için Let's Encrypt kullanılıyor..." ;;
        tr-TR:msg_ssl_domain_ok) printf "✓ SSL sertifikası şu alan adıyla başarıyla yapılandırıldı: %s\n" "$@" ;;
        tr-TR:msg_ssl_domain_extract_failed) echo "SSL kurulumu tamamlanmış olabilir, ancak alan adı çıkarılamadı" ;;
        tr-TR:msg_ssl_domain_failed) echo "Alan adı kipi için SSL sertifikası kurulumu başarısız oldu." ;;
        tr-TR:msg_ssl_le_ip) echo "IP sertifikası için Let's Encrypt kullanılıyor (shortlived profili)..." ;;
        tr-TR:msg_ipv4_confirm_prompt) printf "Bu sunucu için gelen genel IPv4 adresi %s doğru mu? [Default y]:\n" "$@" ;;
        tr-TR:msg_ipv4_prompt) echo "Lütfen sunucunuzun genel IPv4 adresini girin:" ;;
        tr-TR:msg_ipv4_invalid_retry) echo "Geçersiz IPv4 adresi. Lütfen tekrar deneyin." ;;
        tr-TR:msg_ipv6_prompt) echo "Eklemek istediğiniz bir IPv6 adresi var mı? (atlamak için boş bırakın):" ;;
        tr-TR:msg_ipcert_configured) echo "✓ Let's Encrypt IP sertifikası başarıyla yapılandırıldı" ;;
        tr-TR:msg_ipcert_setup_failed) echo "✗ IP sertifikası kurulumu başarısız. Lütfen 80 numaralı bağlantı noktasının açık olduğunu kontrol edin." ;;
        tr-TR:msg_custom_cert_using) echo "Mevcut özel sertifika kullanılıyor..." ;;
        tr-TR:msg_custom_cert_domain_prompt) echo "Lütfen sertifikanın düzenlendiği alan adını girin:" ;;
        tr-TR:msg_custom_cert_path_prompt) echo "Sertifika yolunu girin (anahtar sözcükler: .crt / fullchain):" ;;
        tr-TR:msg_file_missing) echo "Hata: Dosya mevcut değil! Tekrar deneyin." ;;
        tr-TR:msg_file_unreadable) echo "Hata: Dosya var ancak okunamıyor (izinleri kontrol edin)!" ;;
        tr-TR:msg_file_empty) echo "Hata: Dosya boş!" ;;
        tr-TR:msg_custom_key_path_prompt) echo "Özel anahtar yolunu girin (anahtar sözcükler: .key / privatekey):" ;;
        tr-TR:msg_custom_cert_not_applied) echo "✗ Özel sertifika uygulanmadı -- panel düz HTTP sunacaktı." ;;
        tr-TR:msg_custom_cert_applied) echo "✓ Özel sertifika yolları uygulandı." ;;
        tr-TR:msg_custom_cert_renew_note) echo "Not: Bu dosyaları harici olarak yenilemek sizin sorumluluğunuzdadır." ;;
        tr-TR:msg_no_ssl_title) echo "⚠ Panel SSL/TLS OLMADAN kurulacak." ;;
        tr-TR:msg_no_ssl_plaintext) echo "Giriş kimlik bilgileri ve çerezler düz HTTP olarak iletilir." ;;
        tr-TR:msg_no_ssl_safe_when) echo "Yalnızca şu durumlarda güvenlidir:" ;;
        tr-TR:msg_no_ssl_proxy) echo "  • TLS bağlantısını sizin için bir ters proxy (nginx, Caddy, Traefik) sonlandırıyorsa, veya" ;;
        tr-TR:msg_no_ssl_tunnel) echo "  • Panele yalnızca bir SSH tüneli üzerinden erişiyorsanız" ;;
        tr-TR:msg_bind_localhost_prompt) echo "Panel yalnızca 127.0.0.1 adresine bağlansın mı? (önerilir — erişimi SSH tüneli / ters proxy üzerinden zorunlu kılar) [y/N]:" ;;
        tr-TR:msg_panel_localhost_only) echo "✓ Panel yalnızca 127.0.0.1 adresine bağlandı. Artık genel internetten erişilemez." ;;
        tr-TR:msg_ssh_forward_title) echo "SSH Bağlantı Noktası Yönlendirme — paneli yerel makinenizden şu şekilde açın:" ;;
        tr-TR:msg_ssh_cmd_standard) echo "  Standart SSH komutu:" ;;
        tr-TR:msg_ssh_cmd_key) echo "  SSH anahtarı kullanıyorsanız:" ;;
        tr-TR:msg_ssh_cmd_open) echo "  Ardından tarayıcınızda açın:" ;;
        tr-TR:msg_ssh_alt_proxy) printf "Alternatif: bir ters proxy (nginx/Caddy) 127.0.0.1:%s adresine yönlendirin ve TLS bağlantısını onun sonlandırmasını sağlayın.\n" "$@" ;;
        tr-TR:msg_no_ssl_all_interfaces) echo "Panel tüm arayüzlerde düz HTTP üzerinden dinleyecek. Önünde TLS bağlantısını başka bir şeyin sonlandırdığından emin olun." ;;
        tr-TR:msg_ssl_skipped) echo "✓ SSL kurulumu atlandı." ;;
        tr-TR:msg_ssl_option_invalid) echo "Geçersiz seçenek. SSL kurulumu atlanıyor." ;;
        tr-TR:msg_ip_detect_failed) echo "Sunucu IP adresi hiçbir sağlayıcıdan otomatik algılanamadı." ;;
        tr-TR:msg_db_selection_title) echo "Veritabanı Seçimi" ;;
        tr-TR:msg_db_opt_sqlite) echo "1) SQLite     (varsayılan — 500 altı kullanıcı için önerilir)" ;;
        tr-TR:msg_db_opt_pg) echo "2) PostgreSQL (yüksek kullanıcı sayısı / çok sayıda düğüm için önerilir)" ;;
        tr-TR:msg_choose_default) echo "Seçin [1]:" ;;
        tr-TR:msg_db_label_pg_external) echo "PostgreSQL (harici)" ;;
        tr-TR:msg_pg_installing_local) echo "PostgreSQL yerel olarak kuruluyor (etkileşimsiz)..." ;;
        tr-TR:msg_pg_failed_ni) echo "Etkileşimsiz kipte PostgreSQL kurulumu başarısız oldu; iptal ediliyor." ;;
        tr-TR:msg_pg_env_hint) echo "Mevcut bir sunucu kullanmak için EASYXRAY_DB_DSN ayarlayın veya EASYXRAY_DB_TYPE=sqlite kullanın." ;;
        tr-TR:msg_pg_menu_local) echo "1) PostgreSQL yerel olarak kur ve özel bir kullanıcı/veritabanı oluştur (önerilir)" ;;
        tr-TR:msg_pg_menu_external) echo "2) Mevcut bir PostgreSQL sunucusu kullan (DSN girin)" ;;
        tr-TR:msg_pg_dsn_prompt) echo "PostgreSQL DSN değerini girin (postgres://user:pass@host:port/dbname?sslmode=disable):" ;;
        tr-TR:msg_pg_installing) echo "PostgreSQL kuruluyor — bu biraz zaman alabilir..." ;;
        tr-TR:msg_pg_credfile_failed) echo "Geçici kimlik bilgileri dosyası oluşturulamadı." ;;
        tr-TR:msg_pg_failed) echo "PostgreSQL kurulumu başarısız oldu." ;;
        tr-TR:msg_pg_menu_retry) echo "1) Yerel kurulumu yeniden dene" ;;
        tr-TR:msg_pg_menu_dsn) echo "2) Bunun yerine harici bir DSN gir" ;;
        tr-TR:msg_pg_menu_abort) echo "3) Kurulumu iptal et" ;;
        tr-TR:msg_pg_menu_fallback) echo "4) SQLite'a geri dön" ;;
        tr-TR:msg_install_aborted) echo "Kurulum iptal edildi." ;;
        tr-TR:msg_pg_client_missing) echo "⚠ pg_dump/pg_restore kurulamadı. postgresql-client paketini kurana kadar panel içi veritabanı yedekleme/geri yükleme kullanılamayacak." ;;
        tr-TR:msg_panel_port) printf "Panel Bağlantı Noktanız: %s\n" "$@" ;;
        tr-TR:msg_panel_port_random) printf "Rastgele bağlantı noktası oluşturuldu: %s\n" "$@" ;;
        tr-TR:msg_panel_port_customize_prompt) echo "Panel Bağlantı Noktası ayarlarını özelleştirmek ister misiniz? (Aksi halde rastgele bir bağlantı noktası uygulanır) [y/n]:" ;;
        tr-TR:msg_panel_port_prompt) echo "Lütfen panel bağlantı noktasını ayarlayın:" ;;
        tr-TR:msg_ssl_title) echo "SSL Sertifika Kurulumu (ÖNERİLİR)" ;;
        tr-TR:msg_ssl_recommend) echo "SSL şiddetle önerilir. Yalnızca TLS için ters proxy veya SSH tüneli varsa atlayın." ;;
        tr-TR:msg_ssl_le_note) echo "Let's Encrypt artık hem alan adlarını hem de IP adreslerini destekliyor!" ;;
        tr-TR:msg_abort1) echo "Sertifika panele uygulanamadı, bu yüzden bir https:// adresi arkasında düz HTTP sunardı." ;;
        tr-TR:msg_abort2) echo "Başka hiçbir şey değişmedi; sertifikayı düzeltip kurulumu yeniden çalıştırın." ;;
        tr-TR:msg_done_title) echo "Panel Kurulumu Tamamlandı!" ;;
        tr-TR:msg_done_user) echo "Kullanıcı Adı:" ;;
        tr-TR:msg_done_pass) echo "Şifre:" ;;
        tr-TR:msg_done_port) echo "Bağlantı Noktası:" ;;
        tr-TR:msg_done_wbp) echo "Web Taban Yolu:" ;;
        tr-TR:msg_done_db) echo "Veritabanı:" ;;
        tr-TR:msg_done_token) echo "API Jetonu:" ;;
        tr-TR:msg_done_save) echo "ÖNEMLİ: Bu kimlik bilgilerini güvenli bir yerde saklayın!" ;;
        tr-TR:msg_ssl_on) echo "SSL Sertifikası: etkin ve yapılandırıldı" ;;
        tr-TR:msg_ssl_off) echo "SSL Sertifikası: atlandı; panel yalnızca HTTP. Ters proxy veya SSH tüneli kullanın." ;;
        tr-TR:msg_pg_backup_title) echo "PostgreSQL yedekleme ve geri yükleme panele yerleşiktir:" ;;
        tr-TR:msg_pg_backup_menu) echo "→ Yedekle ve Geri Yükle" ;;
        tr-TR:msg_pg_backup_note) echo "  Yedekle bir pg_dump .dump dosyası indirir; Geri Yükle onu pg_restore ile geri yükler." ;;
        tr-TR:msg_pg_creds_title) echo "PostgreSQL Kimlik Bilgileri" ;;
        tr-TR:msg_pg_db_name) echo "Veritabanı Adı:" ;;
        tr-TR:msg_pg_username) echo "Kullanıcı Adı:" ;;
        tr-TR:msg_pg_password) echo "Şifre:" ;;
        tr-TR:msg_pg_host) echo "Sunucu:" ;;
        tr-TR:msg_pg_port) echo "Bağlantı Noktası:" ;;
        tr-TR:msg_pg_dsn) echo "DSN:" ;;
        tr-TR:msg_pg_env_file) echo "Ortam dosyası:" ;;
        tr-TR:msg_pg_connect) echo "Bu sunucudan bağlanın:" ;;
        tr-TR:msg_pg_as_superuser) echo "(postgres süper kullanıcısı olarak)" ;;
        tr-TR:msg_pg_env_read) printf "⚠ Panel bu kimlik bilgilerini %s dosyasından okur.\n" "$@" ;;
        tr-TR:msg_pg_save_password) echo "⚠ Şifreyi kaydedin — başka hiçbir yerde düz metin olarak saklanmaz." ;;
        tr-TR:msg_wbp_generating) echo "WebBasePath eksik veya çok kısa. Yeni bir tane oluşturuluyor..." ;;
        tr-TR:msg_wbp_new) printf "Yeni WebBasePath: %s\n" "$@" ;;
        tr-TR:msg_default_creds) echo "Varsayılan kimlik bilgileri algılandı. Güvenlik güncellemesi gerekli..." ;;
        tr-TR:msg_new_creds) echo "Yeni rastgele giriş kimlik bilgileri oluşturuldu:" ;;
        tr-TR:msg_creds_set) echo "Kullanıcı Adı, Şifre ve WebBasePath doğru şekilde ayarlandı." ;;
        tr-TR:msg_ssl_already_configured) echo "SSL sertifikası zaten yapılandırılmış. İşlem gerekmez." ;;
        tr-TR:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s, Fail2ban otomatik kurulumu atlanıyor.\n" "$@" ;;
        tr-TR:msg_f2b_skipped_cli) echo "easyxray CLI bulunamadı; Fail2ban otomatik kurulumu atlanıyor." ;;
        tr-TR:msg_f2b_skipped_old) echo "Bu easyxray.sh, 'easyxray setup-fail2ban' komutundan daha eski; Fail2ban otomatik kurulumu atlanıyor." ;;
        tr-TR:msg_f2b_setup) echo "IP Sınırı özelliği için Fail2ban ayarlanıyor..." ;;
        tr-TR:msg_f2b_done) echo "Fail2ban kurulumu tamamlandı." ;;
        tr-TR:msg_f2b_incomplete) echo "Fail2ban kurulumu tamamlanmadı; 'easyxray' komutunu çalıştırıp IP Sınırı menüsünü açana kadar IP Sınırı devre dışı kalır. Devam ediliyor." ;;
        tr-TR:msg_systemd_hardening_note) printf "Not: systemd %s, easyxray.service içindeki sıkılaştırmanın bir kısmını yok sayar; panel yine de başlar.\n" "$@" ;;
        tr-TR:msg_systemd_hardening_missing) printf "      Uygulanmadı, daha yeni bir systemd gerekiyor: %s.\n" "$@" ;;
        tr-TR:msg_systemd_hardening_alias) echo "      Panel klasörleri, bu betiğin kurduğu takma ad olan ReadWriteDirectories= sayesinde yazılabilir kalır." ;;
        tr-TR:msg_systemd_hardening_rest) echo "      Sıkılaştırmanın geri kalanı yürürlükte. Yukarıdakileri uygulamak için systemd sürümünü yükseltin." ;;
        tr-TR:msg_ws_warn_head) echo "Uyarı: bu klasörler boşluk içeriyor ve şu dosyanın dışında bırakıldı" ;;
        tr-TR:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf: %s\n" "$@" ;;
        tr-TR:msg_ws_warn_tail) echo "         Panel, birimin korumalı alanı altında bu klasörlere yazamaz." ;;
        tr-TR:msg_sandbox_refresh_failed) printf "Uyarı: %s/easyxray.service.d/10-easyxray-sandbox.conf yenilenemedi.\n" "$@" ;;
        tr-TR:msg_sandbox_write_hint) echo "EASYXRAY_DB_FOLDER veya EASYXRAY_LOG_FOLDER, /etc/easyxray ve /var/log/easyxray dışını gösteriyorsa panel ProtectSystem=full altında oraya yazamayabilir." ;;
        tr-TR:msg_checksum_none) echo "Bu sürüm için sağlama toplamı yayımlanmamış, doğrulama atlanıyor" ;;
        tr-TR:msg_checksum_download_failed) printf "%s için sağlama toplamı indirilemedi (HTTP %s)\n" "$@" ;;
        tr-TR:msg_checksum_mismatch) printf "%s için sağlama toplamı uyuşmuyor: beklenen %s, alınan %s\n" "$@" ;;
        tr-TR:msg_checksum_ok) printf "Sağlama toplamı doğrulandı: %s\n" "$@" ;;
        tr-TR:msg_repo_file_missing) printf "%s, %s için mevcut değil (HTTP %s)\n" "$@" ;;
        tr-TR:msg_repo_file_missing_hint) echo "Onu içeren bir sürümü kurun veya sürekli güncellenen derleme için 'dev' kullanın. Mevcut kurulumunuza dokunulmadı." ;;
        tr-TR:msg_version_fetch_failed) echo "easyxray sürümü alınamadı, buna GitHub API kısıtlamaları neden olabilir, lütfen daha sonra tekrar deneyin" ;;
        tr-TR:msg_latest_version) printf "easyxray en son sürümü alındı: %s, kurulum başlıyor...\n" "$@" ;;
        tr-TR:msg_download_failed) echo "easyxray indirme başarısız oldu, lütfen sunucunuzun GitHub'a erişebildiğinden emin olun" ;;
        tr-TR:msg_archive_empty) echo "İndirilen easyxray sürüm arşivi boş" ;;
        tr-TR:msg_dev_build) echo "Sürekli güncellenen dev derlemesi kuruluyor (etiket: dev-latest). Bu her commit için bir ön sürümdür, kararlı bir sürüm değildir." ;;
        tr-TR:msg_install_start) echo "Kurulum başlıyor:" ;;
        tr-TR:msg_download_version_failed) printf "easyxray %s indirilemedi, lütfen sürümün mevcut olup olmadığını kontrol edin\n" "$@" ;;
        tr-TR:msg_script_download_failed) echo "easyxray.sh indirilemedi" ;;
        tr-TR:msg_script_empty) echo "İndirilen easyxray.sh boş" ;;
        tr-TR:msg_bin_backup_failed) echo "bin/ klasörü yedeklenemedi -- oradaki özel dosyalar bu güncellemede korunmayacak" ;;
        tr-TR:msg_extract_failed) echo "easyxray sürüm arşivi çıkarılamadı -- önceki kurulum zaten kaldırıldı, bu yüzden bu düzeltilene kadar panel başlamayacak; kurulum betiğini tekrar çalıştırmayı deneyin" ;;
        tr-TR:msg_binary_missing) echo "Çıkarılan easyxray arşivinde easyxray ikili dosyası yok -- önceki kurulum zaten kaldırıldı, bu yüzden bu düzeltilene kadar panel başlamayacak; kurulum betiğini tekrar çalıştırmayı deneyin" ;;
        tr-TR:msg_bin_restored) printf "Bu sürümle birlikte gelmeyen bin/ içindeki özel dosyalar geri yüklendi: %s\n" "$@" ;;
        tr-TR:msg_script_install_failed) echo "easyxray.sh kurulamadı" ;;
        tr-TR:msg_gitignore_added) echo "etckeeper için /etc/.gitignore dosyasına EasyXray.db eklendi" ;;
        tr-TR:msg_gitignore_created) echo "/etc/.gitignore oluşturuldu ve etckeeper için EasyXray.db eklendi" ;;
        tr-TR:msg_rc_download_failed) echo "easyxray.rc indirilemedi" ;;
        tr-TR:msg_rc_empty) echo "İndirilen easyxray.rc boş" ;;
        tr-TR:msg_rc_install_failed) echo "easyxray.rc kurulamadı" ;;
        tr-TR:msg_service_found) echo "Çıkarılan dosyalarda easyxray.service bulundu, kuruluyor..." ;;
        tr-TR:msg_service_found_variant) printf "Çıkarılan dosyalarda easyxray.service.%s bulundu, kuruluyor...\n" "$@" ;;
        tr-TR:msg_service_downloading) echo "Hizmet dosyaları tar.gz içinde bulunamadı, GitHub'dan indiriliyor..." ;;
        tr-TR:msg_service_install_failed) printf "easyxray.service GitHub'dan kurulamadı (%s) -- sürüm tarball'ı da bir tane içermiyordu\n" "$@" ;;
        tr-TR:msg_systemd_setup) echo "systemd birimi ayarlanıyor..." ;;
        tr-TR:msg_service_file_failed) echo "easyxray.service dosyası kurulamadı" ;;
        tr-TR:msg_installed_ok) echo "kurulum tamamlandı, şu anda çalışıyor..." ;;
        tr-TR:msg_running) echo "Çalışıyor..." ;;
        tr-TR:msg_menu_admin) echo "Yönetici Yönetim Betiği" ;;
        tr-TR:msg_menu_start) echo "Başlat" ;;
        tr-TR:msg_menu_stop) echo "Durdur" ;;
        tr-TR:msg_menu_restart) echo "Yeniden Başlat" ;;
        tr-TR:msg_menu_status) echo "Mevcut Durum" ;;
        tr-TR:msg_menu_settings) echo "Mevcut Ayarlar" ;;
        tr-TR:msg_menu_enable) echo "İşletim Sistemi Başlangıcında Otomatik Başlatmayı Etkinleştir" ;;
        tr-TR:msg_menu_disable) echo "İşletim Sistemi Başlangıcında Otomatik Başlatmayı Devre Dışı Bırak" ;;
        tr-TR:msg_menu_log) echo "Günlükleri kontrol et" ;;
        tr-TR:msg_menu_banlog) echo "Fail2ban yasaklama günlüklerini kontrol et" ;;
        tr-TR:msg_menu_update) echo "Güncelle" ;;
        tr-TR:msg_menu_legacy) echo "Eski sürüm" ;;
        tr-TR:msg_menu_install) echo "Yükle" ;;
        tr-TR:msg_menu_uninstall) echo "Kaldır" ;;
        # ---- pt-BR ----
        pt-BR:msg_lang_menu_title) echo "Selecione o idioma da instalação:" ;;
        pt-BR:msg_lang_invalid) echo "Opção inválida; mantendo o idioma atual." ;;
        pt-BR:msg_root_required) echo "Erro fatal: execute este script com privilégios de root" ;;
        pt-BR:msg_menu_title) echo "Uso do menu de controle do easyxray (subcomandos):" ;;
        pt-BR:msg_unsupported_arch) echo "Arquitetura de CPU não suportada." ;;
        pt-BR:msg_arch) printf "Arquitetura: %s\n" "$@" ;;
        pt-BR:msg_os_check_failed) echo "Falha ao verificar o sistema operacional, entre em contato com o autor!" ;;
        pt-BR:msg_os_release) printf "A versão do sistema operacional é: %s\n" "$@" ;;
        pt-BR:msg_cert_not_pem) echo "o certificado ou a chave privada não é um arquivo PEM legível" ;;
        pt-BR:msg_cert_key_mismatch) echo "a chave privada não corresponde ao certificado" ;;
        pt-BR:msg_cert_file_unreadable) printf "O arquivo do certificado está ausente, vazio ou ilegível: %s\n" "$@" ;;
        pt-BR:msg_cert_key_unreadable) printf "O arquivo da chave privada está ausente, vazio ou ilegível: %s\n" "$@" ;;
        pt-BR:msg_cert_cli_failed) printf "easyxray cert saiu com o código %s: %s\n" "$@" ;;
        pt-BR:msg_cert_not_saved) printf "O painel não salvou o certificado (cert salvo=%s, key=%s)\n" "$@" ;;
        pt-BR:msg_result_write_failed) printf "Aviso: falha ao gravar %s.\n" "$@" ;;
        pt-BR:msg_result_written) printf "Resultado da instalação gravado em %s (modo 600).\n" "$@" ;;
        pt-BR:msg_pg_pgdg_fallback) printf "O PostgreSQL %s não está disponível para este sistema; instalando o PostgreSQL da distribuição em vez dele.\n" "$@" ;;
        pt-BR:msg_pg_distro_unsupported) printf "Distribuição não suportada para instalação automática do PostgreSQL: %s\n" "$@" ;;
        pt-BR:msg_pg_hba_warn) echo "Aviso: falha ao atualizar o pg_hba.conf; o PostgreSQL pode rejeitar o login TCP do painel (autenticação ident)." ;;
        pt-BR:msg_pg_cred_write_failed) printf "Falha ao gravar as credenciais do PostgreSQL em %s\n" "$@" ;;
        pt-BR:msg_pg_client_tools) echo "Instalando as ferramentas cliente do PostgreSQL (pg_dump/pg_restore) para o backup pelo painel..." ;;
        pt-BR:msg_acme_installing_ssl) echo "Instalando o acme.sh para o gerenciamento de certificados SSL..." ;;
        pt-BR:msg_acme_failed) echo "Falha ao instalar o acme.sh" ;;
        pt-BR:msg_acme_ok) echo "acme.sh instalado com sucesso" ;;
        pt-BR:msg_ssl_setup_start) echo "Configurando o certificado SSL..." ;;
        pt-BR:msg_acme_failed_skip) echo "Falha ao instalar o acme.sh; pulando a configuração de SSL" ;;
        pt-BR:msg_ssl_issuing_domain) printf "Emitindo o certificado SSL para %s...\n" "$@" ;;
        pt-BR:msg_ssl_port80_note) echo "Observação: a porta 80 precisa estar aberta e acessível pela internet" ;;
        pt-BR:msg_ssl_issue_failed) printf "Falha ao emitir o certificado para %s\n" "$@" ;;
        pt-BR:msg_ssl_retry_hint) echo "Verifique se a porta 80 está aberta e tente novamente mais tarde com: easyxray" ;;
        pt-BR:msg_ssl_install_failed) echo "Falha ao instalar o certificado" ;;
        pt-BR:msg_ssl_installed) echo "Certificado SSL instalado e configurado com sucesso!" ;;
        pt-BR:msg_cert_files_not_found) echo "Arquivos do certificado não encontrados" ;;
        pt-BR:msg_ipcert_setup) echo "Configurando o certificado de IP do Let's Encrypt (perfil shortlived)..." ;;
        pt-BR:msg_ipcert_validity_note) echo "Observação: os certificados de IP são válidos por ~6 dias e se renovam automaticamente." ;;
        pt-BR:msg_ipcert_port_note) echo "O listener padrão é a porta 80. Se você escolher outra porta, garanta que a porta 80 externa seja encaminhada para ela." ;;
        pt-BR:msg_ipv4_required) echo "É necessário um endereço IPv4" ;;
        pt-BR:msg_ipv4_invalid) printf "Endereço IPv4 inválido: %s\n" "$@" ;;
        pt-BR:msg_ipv6_included) printf "Incluindo o endereço IPv6: %s\n" "$@" ;;
        pt-BR:msg_acme_port_prompt) echo "Porta para o listener HTTP-01 do ACME (padrão 80):" ;;
        pt-BR:msg_port_invalid_fallback) echo "Porta inválida fornecida. Usando a 80." ;;
        pt-BR:msg_port_using) printf "Usando a porta %s para validação independente.\n" "$@" ;;
        pt-BR:msg_port_forward_note) printf "Lembrete: o Let's Encrypt ainda se conecta na porta 80; encaminhe a porta 80 externa para %s.\n" "$@" ;;
        pt-BR:msg_port_in_use) printf "A porta %s está em uso.\n" "$@" ;;
        pt-BR:msg_port_busy_ni) printf "A porta %s está ocupada; não é possível continuar no modo não interativo.\n" "$@" ;;
        pt-BR:msg_acme_port_retry_prompt) echo "Informe outra porta para o listener standalone do acme.sh (deixe vazio para cancelar):" ;;
        pt-BR:msg_port_busy) printf "A porta %s está ocupada; não é possível continuar.\n" "$@" ;;
        pt-BR:msg_port_invalid) echo "Porta inválida fornecida." ;;
        pt-BR:msg_port_free) printf "A porta %s está livre e pronta para validação independente.\n" "$@" ;;
        pt-BR:msg_ipcert_issuing) printf "Emitindo o certificado de IP para %s...\n" "$@" ;;
        pt-BR:msg_ipcert_issue_failed) echo "Falha ao emitir o certificado de IP" ;;
        pt-BR:msg_ipcert_port_hint) printf "Verifique se a porta %s está acessível (ou encaminhada da porta 80 externa)\n" "$@" ;;
        pt-BR:msg_cert_issued_installing) echo "Certificado emitido com sucesso, instalando..." ;;
        pt-BR:msg_cert_files_missing) echo "Arquivos do certificado não encontrados após a instalação" ;;
        pt-BR:msg_cert_files_installed) echo "Arquivos do certificado instalados com sucesso" ;;
        pt-BR:msg_cert_paths_setting) echo "Configurando os caminhos do certificado para o painel..." ;;
        pt-BR:msg_cert_files_at) echo "Os arquivos do certificado estão em:" ;;
        pt-BR:msg_cert_file) echo "Arquivo do certificado:" ;;
        pt-BR:msg_cert_key) echo "Arquivo da chave privada:" ;;
        pt-BR:msg_cert_paths_ok) echo "Caminhos do certificado definidos para o painel" ;;
        pt-BR:msg_ipcert_installed) echo "Certificado de IP instalado e configurado com sucesso!" ;;
        pt-BR:msg_ipcert_autorenew) echo "Certificado válido por ~6 dias, renova automaticamente via tarefa cron do acme.sh." ;;
        pt-BR:msg_acme_autorenew) echo "O acme.sh renovará e recarregará o easyxray automaticamente antes do vencimento." ;;
        pt-BR:msg_acme_installing) echo "Instalando acme.sh..." ;;
        pt-BR:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain requer um EASYXRAY_DOMAIN válido (recebido: '%s').\n" "$@" ;;
        pt-BR:msg_domain_prompt) echo "Digite seu nome de domínio: " ;;
        pt-BR:msg_domain_empty) echo "O nome de domínio não pode ficar vazio. Tente novamente." ;;
        pt-BR:msg_domain_invalid) echo "Formato de domínio inválido. Digite um nome de domínio válido." ;;
        pt-BR:msg_domain_checking) printf "Seu domínio é: %s, verificando...\n" "$@" ;;
        pt-BR:msg_cert_existing_reuse) printf "Certificado existente encontrado para %s, ele será reutilizado.\n" "$@" ;;
        pt-BR:msg_acme_state_incomplete) printf "Estado incompleto do acme.sh encontrado para %s (sem arquivos de certificado válidos); limpando e emitindo novamente.\n" "$@" ;;
        pt-BR:msg_domain_ready) echo "Seu domínio já está pronto para emitir certificados..." ;;
        pt-BR:msg_acme_port_choose_prompt) echo "Escolha qual porta usar (o padrão é a 80):" ;;
        pt-BR:msg_port_input_invalid) printf "Sua entrada %s é inválida, será usada a porta padrão 80.\n" "$@" ;;
        pt-BR:msg_port_will_use) printf "Será usada a porta: %s para emitir os certificados. Verifique se esta porta está aberta.\n" "$@" ;;
        pt-BR:msg_panel_stopping) echo "Parando o painel temporariamente..." ;;
        pt-BR:msg_cert_issue_failed_logs) echo "Falha ao emitir o certificado, verifique os logs." ;;
        pt-BR:msg_cert_issue_succeeded) echo "Certificado emitido com sucesso, instalando os certificados..." ;;
        pt-BR:msg_cert_using_existing) echo "Usando o certificado existente, instalando os certificados..." ;;
        pt-BR:msg_reloadcmd_default) echo "O --reloadcmd padrão para o ACME é:" ;;
        pt-BR:msg_reloadcmd_runs_on) echo "Este comando será executado em cada emissão e renovação do certificado." ;;
        pt-BR:msg_reloadcmd_modify_prompt) echo "Deseja modificar o --reloadcmd do ACME? (y/n):" ;;
        pt-BR:msg_reloadcmd_preset) echo "Predefinição: systemctl reload nginx ; systemctl restart easyxray" ;;
        pt-BR:msg_reloadcmd_custom) echo "Informe seu próprio comando" ;;
        pt-BR:msg_reloadcmd_keep_default) echo "Manter o reloadcmd padrão" ;;
        pt-BR:msg_reloadcmd_option_prompt) echo "Escolha uma opção:" ;;
        pt-BR:msg_reloadcmd_is_preset) echo "O reloadcmd é: systemctl reload nginx ; systemctl restart easyxray" ;;
        pt-BR:msg_reloadcmd_order) echo "Recomenda-se colocar o reinício do easyxray no final" ;;
        pt-BR:msg_reloadcmd_custom_prompt) echo "Informe o seu reloadcmd personalizado:" ;;
        pt-BR:msg_reloadcmd_is) printf "O reloadcmd é: %s\n" "$@" ;;
        pt-BR:msg_reloadcmd_keeping) echo "Mantendo o reloadcmd padrão" ;;
        pt-BR:msg_cert_installed_autorenew) echo "Certificado instalado com sucesso, ativando a renovação automática..." ;;
        pt-BR:msg_cert_install_failed_exit) echo "Falha ao instalar o certificado, saindo." ;;
        pt-BR:msg_autorenew_issues) echo "A configuração da renovação automática teve problemas, detalhes do certificado:" ;;
        pt-BR:msg_autorenew_ok) echo "Renovação automática concluída com sucesso, detalhes do certificado:" ;;
        pt-BR:msg_cert_set_panel_prompt) echo "Deseja definir este certificado para o painel? (y/n):" ;;
        pt-BR:msg_done_url) echo "URL de acesso:" ;;
        pt-BR:msg_cert_restart) echo "O painel será reiniciado para aplicar o certificado SSL..." ;;
        pt-BR:msg_cert_rejected) echo "Erro: o painel recusou o certificado, então ele serviria HTTP sem criptografia." ;;
        pt-BR:msg_skip_panel_path) echo "Pulando a configuração do caminho do painel." ;;
        pt-BR:msg_ssl_choose) echo "Escolha o método de configuração do certificado SSL:" ;;
        pt-BR:msg_ssl_opt1) echo "Let's Encrypt para domínio (validade de 90 dias, renovação automática)" ;;
        pt-BR:msg_ssl_opt2) echo "Let's Encrypt para endereço IP (validade de 6 dias, renovação automática)" ;;
        pt-BR:msg_ssl_opt3) echo "Certificado Digital SSL personalizado (Caminho para arquivos existentes)" ;;
        pt-BR:msg_ssl_opt4) echo "Pular SSL (avançado: apenas atrás de proxy reverso ou túnel SSH)" ;;
        pt-BR:msg_ssl_note_opts) echo "Observação: as opções 1 e 2 exigem a porta 80 aberta. A opção 3 exige caminhos manuais." ;;
        pt-BR:msg_ssl_note_opt4) echo "Observação: a opção 4 serve o painel via HTTP sem criptografia; só é segura atrás do nginx/Caddy ou de um túnel SSH." ;;
        pt-BR:msg_ssl_mode_unknown) printf "EASYXRAY_SSL_MODE='%s' desconhecido, usando none (HTTP) como padrão.\n" "$@" ;;
        pt-BR:msg_ssl_pick) echo "Escolha uma opção (padrão 2 para IP): " ;;
        pt-BR:msg_ssl_le_domain) echo "Usando o Let's Encrypt para o certificado de domínio..." ;;
        pt-BR:msg_ssl_domain_ok) printf "✓ Certificado SSL configurado com sucesso com o domínio: %s\n" "$@" ;;
        pt-BR:msg_ssl_domain_extract_failed) echo "A configuração do SSL pode ter sido concluída, mas a extração do domínio falhou" ;;
        pt-BR:msg_ssl_domain_failed) echo "A configuração do certificado SSL falhou no modo domínio." ;;
        pt-BR:msg_ssl_le_ip) echo "Usando o Let's Encrypt para o certificado de IP (perfil shortlived)..." ;;
        pt-BR:msg_ipv4_confirm_prompt) printf "%s é o endereço IPv4 público de entrada correto deste servidor? [Default y]:\n" "$@" ;;
        pt-BR:msg_ipv4_prompt) echo "Informe o endereço IPv4 público do seu servidor:" ;;
        pt-BR:msg_ipv4_invalid_retry) echo "Endereço IPv4 inválido. Tente novamente." ;;
        pt-BR:msg_ipv6_prompt) echo "Você tem um endereço IPv6 para incluir? (deixe vazio para ignorar):" ;;
        pt-BR:msg_ipcert_configured) echo "✓ Certificado de IP do Let's Encrypt configurado com sucesso" ;;
        pt-BR:msg_ipcert_setup_failed) echo "✗ A configuração do certificado de IP falhou. Verifique se a porta 80 está aberta." ;;
        pt-BR:msg_custom_cert_using) echo "Usando o certificado personalizado existente..." ;;
        pt-BR:msg_custom_cert_domain_prompt) echo "Informe o nome de domínio para o qual o certificado foi emitido:" ;;
        pt-BR:msg_custom_cert_path_prompt) echo "Informe o caminho do certificado (palavras-chave: .crt / fullchain):" ;;
        pt-BR:msg_file_missing) echo "Erro: o arquivo não existe. Tente novamente." ;;
        pt-BR:msg_file_unreadable) echo "Erro: o arquivo existe, mas não pode ser lido (verifique as permissões)." ;;
        pt-BR:msg_file_empty) echo "Erro: o arquivo está vazio." ;;
        pt-BR:msg_custom_key_path_prompt) echo "Informe o caminho da chave privada (palavras-chave: .key / privatekey):" ;;
        pt-BR:msg_custom_cert_not_applied) echo "✗ O certificado personalizado não foi aplicado; o painel serviria via HTTP sem criptografia." ;;
        pt-BR:msg_custom_cert_applied) echo "✓ Caminhos do certificado personalizado aplicados." ;;
        pt-BR:msg_custom_cert_renew_note) echo "Observação: você é responsável por renovar esses arquivos externamente." ;;
        pt-BR:msg_no_ssl_title) echo "⚠ O painel será instalado SEM SSL/TLS." ;;
        pt-BR:msg_no_ssl_plaintext) echo "As credenciais de login e os cookies trafegarão via HTTP sem criptografia." ;;
        pt-BR:msg_no_ssl_safe_when) echo "Só é seguro quando:" ;;
        pt-BR:msg_no_ssl_proxy) echo "  • Um proxy reverso (nginx, Caddy, Traefik) termina o TLS para você, ou" ;;
        pt-BR:msg_no_ssl_tunnel) echo "  • Você acessa o painel exclusivamente por um túnel SSH" ;;
        pt-BR:msg_bind_localhost_prompt) echo "Vincular o painel apenas a 127.0.0.1? (recomendado — força o acesso por túnel SSH ou proxy reverso) [y/N]:" ;;
        pt-BR:msg_panel_localhost_only) echo "✓ Painel vinculado apenas a 127.0.0.1. Agora ele é inacessível pela internet pública." ;;
        pt-BR:msg_ssh_forward_title) echo "Encaminhamento de porta SSH — abra o painel a partir da sua máquina local via:" ;;
        pt-BR:msg_ssh_cmd_standard) echo "  Comando SSH padrão:" ;;
        pt-BR:msg_ssh_cmd_key) echo "  Se estiver usando uma chave SSH:" ;;
        pt-BR:msg_ssh_cmd_open) echo "  Depois abra no seu navegador:" ;;
        pt-BR:msg_ssh_alt_proxy) printf "Alternativa: aponte um proxy reverso (nginx/Caddy) para 127.0.0.1:%s e deixe que ele termine o TLS.\n" "$@" ;;
        pt-BR:msg_no_ssl_all_interfaces) echo "O painel escutará em todas as interfaces via HTTP sem criptografia. Garanta que algo mais esteja terminando o TLS na frente dele." ;;
        pt-BR:msg_ssl_skipped) echo "✓ Configuração do SSL ignorada." ;;
        pt-BR:msg_ssl_option_invalid) echo "Opção inválida. Ignorando a configuração do SSL." ;;
        pt-BR:msg_ip_detect_failed) echo "Não foi possível detectar automaticamente o IP do servidor em nenhum provedor." ;;
        pt-BR:msg_db_selection_title) echo "Seleção de banco de dados" ;;
        pt-BR:msg_db_opt_sqlite) echo "1) SQLite     (padrão — recomendado para menos de 500 clientes)" ;;
        pt-BR:msg_db_opt_pg) echo "2) PostgreSQL (recomendado para muitos clientes / muitos nós)" ;;
        pt-BR:msg_choose_default) echo "Escolha [1]:" ;;
        pt-BR:msg_db_label_pg_external) echo "PostgreSQL (externo)" ;;
        pt-BR:msg_pg_installing_local) echo "Instalando o PostgreSQL localmente (não interativo)..." ;;
        pt-BR:msg_pg_failed_ni) echo "A instalação do PostgreSQL falhou no modo não interativo; abortando." ;;
        pt-BR:msg_pg_env_hint) echo "Defina EASYXRAY_DB_DSN para usar um servidor existente, ou EASYXRAY_DB_TYPE=sqlite." ;;
        pt-BR:msg_pg_menu_local) echo "1) Instalar o PostgreSQL localmente e criar um usuário e banco de dados dedicados (recomendado)" ;;
        pt-BR:msg_pg_menu_external) echo "2) Usar um servidor PostgreSQL existente (informar o DSN)" ;;
        pt-BR:msg_pg_dsn_prompt) echo "Informe o DSN do PostgreSQL (postgres://user:pass@host:port/dbname?sslmode=disable):" ;;
        pt-BR:msg_pg_installing) echo "Instalando o PostgreSQL — isso pode levar um momento..." ;;
        pt-BR:msg_pg_credfile_failed) echo "Falha ao criar o arquivo temporário de credenciais." ;;
        pt-BR:msg_pg_failed) echo "A instalação do PostgreSQL falhou." ;;
        pt-BR:msg_pg_menu_retry) echo "1) Tentar novamente a instalação local" ;;
        pt-BR:msg_pg_menu_dsn) echo "2) Informar um DSN externo em vez disso" ;;
        pt-BR:msg_pg_menu_abort) echo "3) Abortar a instalação" ;;
        pt-BR:msg_pg_menu_fallback) echo "4) Recorrer ao SQLite" ;;
        pt-BR:msg_install_aborted) echo "Instalação abortada." ;;
        pt-BR:msg_pg_client_missing) echo "⚠ Falha ao instalar pg_dump/pg_restore. O backup e a restauração do banco de dados pelo painel ficarão indisponíveis até você instalar o pacote postgresql-client." ;;
        pt-BR:msg_panel_port) printf "A porta do seu painel é: %s\n" "$@" ;;
        pt-BR:msg_panel_port_random) printf "Porta aleatória gerada: %s\n" "$@" ;;
        pt-BR:msg_panel_port_customize_prompt) echo "Deseja personalizar as configurações da porta do painel? (Caso contrário, uma porta aleatória será aplicada) [y/n]:" ;;
        pt-BR:msg_panel_port_prompt) echo "Defina a porta do painel:" ;;
        pt-BR:msg_ssl_title) echo "Configuração do Certificado SSL (RECOMENDADO)" ;;
        pt-BR:msg_ssl_recommend) echo "O SSL é muito recomendado. Ignore apenas se um proxy reverso ou túnel SSH cuidar do TLS." ;;
        pt-BR:msg_ssl_le_note) echo "O Let's Encrypt agora suporta domínios e endereços IP!" ;;
        pt-BR:msg_abort1) echo "Não foi possível aplicar o certificado ao painel, então serviria HTTP sem criptografia atrás de uma URL https://." ;;
        pt-BR:msg_abort2) echo "Nada mais foi alterado; corrija o certificado e execute o instalador novamente." ;;
        pt-BR:msg_done_title) echo "Instalação do Painel Concluída!" ;;
        pt-BR:msg_done_user) echo "Nome de Usuário:" ;;
        pt-BR:msg_done_pass) echo "Senha:" ;;
        pt-BR:msg_done_port) echo "Porta:" ;;
        pt-BR:msg_done_wbp) echo "Caminho base web:" ;;
        pt-BR:msg_done_db) echo "Banco de dados:" ;;
        pt-BR:msg_done_token) echo "Token da API:" ;;
        pt-BR:msg_done_save) echo "IMPORTANTE: Guarde estas credenciais com segurança!" ;;
        pt-BR:msg_ssl_on) echo "Certificado SSL: habilitado e configurado" ;;
        pt-BR:msg_ssl_off) echo "Certificado SSL: ignorado; o painel é somente HTTP. Use um proxy reverso ou túnel SSH." ;;
        pt-BR:msg_pg_backup_title) echo "O backup e a restauração do PostgreSQL são integrados ao painel:" ;;
        pt-BR:msg_pg_backup_menu) echo "→ Backup & Restauração" ;;
        pt-BR:msg_pg_backup_note) echo "  Backup baixa um arquivo .dump do pg_dump; Restaurar o recarrega com pg_restore." ;;
        pt-BR:msg_pg_creds_title) echo "Credenciais do PostgreSQL" ;;
        pt-BR:msg_pg_db_name) echo "Nome do banco de dados:" ;;
        pt-BR:msg_pg_username) echo "Nome de usuário:" ;;
        pt-BR:msg_pg_password) echo "Senha:" ;;
        pt-BR:msg_pg_host) echo "Servidor:" ;;
        pt-BR:msg_pg_port) echo "Porta:" ;;
        pt-BR:msg_pg_dsn) echo "DSN:" ;;
        pt-BR:msg_pg_env_file) echo "Arquivo de ambiente:" ;;
        pt-BR:msg_pg_connect) echo "Conectar a partir deste servidor:" ;;
        pt-BR:msg_pg_as_superuser) echo "(como o superusuário postgres)" ;;
        pt-BR:msg_pg_env_read) printf "⚠ O painel lê essas credenciais de %s.\n" "$@" ;;
        pt-BR:msg_pg_save_password) echo "⚠ Salve a senha; ela não é armazenada em nenhum outro lugar em texto puro." ;;
        pt-BR:msg_wbp_generating) echo "O WebBasePath está ausente ou muito curto. Gerando um novo..." ;;
        pt-BR:msg_wbp_new) printf "Novo WebBasePath: %s\n" "$@" ;;
        pt-BR:msg_default_creds) echo "Credenciais padrão detectadas. Atualização de segurança necessária..." ;;
        pt-BR:msg_new_creds) echo "Novas credenciais de login aleatórias geradas:" ;;
        pt-BR:msg_creds_set) echo "Nome de usuário, senha e WebBasePath estão configurados corretamente." ;;
        pt-BR:msg_ssl_already_configured) echo "O certificado SSL já está configurado. Nenhuma ação necessária." ;;
        pt-BR:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s, ignorando a configuração automática do Fail2ban.\n" "$@" ;;
        pt-BR:msg_f2b_skipped_cli) echo "CLI do easyxray não encontrada; ignorando a configuração automática do Fail2ban." ;;
        pt-BR:msg_f2b_skipped_old) echo "Este easyxray.sh é anterior ao 'easyxray setup-fail2ban'; ignorando a configuração automática do Fail2ban." ;;
        pt-BR:msg_f2b_setup) echo "Configurando o Fail2ban para o recurso de limite de IP..." ;;
        pt-BR:msg_f2b_done) echo "Configuração do Fail2ban concluída." ;;
        pt-BR:msg_f2b_incomplete) echo "A configuração do Fail2ban não foi concluída; o limite de IP permanece desativado até você executar 'easyxray' e abrir o menu de limite de IP. Continuando." ;;
        pt-BR:msg_systemd_hardening_note) printf "Observação: o systemd %s ignora parte do endurecimento em easyxray.service; o painel ainda inicia.\n" "$@" ;;
        pt-BR:msg_systemd_hardening_missing) printf "      Não aplicado, requer um systemd mais recente: %s.\n" "$@" ;;
        pt-BR:msg_systemd_hardening_alias) echo "      As pastas do painel permanecem graváveis através de ReadWriteDirectories=, o alias que este script instala." ;;
        pt-BR:msg_systemd_hardening_rest) echo "      O restante do endurecimento está em vigor. Atualize o systemd para aplicar o acima." ;;
        pt-BR:msg_ws_warn_head) echo "Aviso: estas pastas contêm espaços em branco e foram deixadas fora de" ;;
        pt-BR:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf: %s\n" "$@" ;;
        pt-BR:msg_ws_warn_tail) echo "         O painel não pode gravar nelas sob o sandbox da unidade." ;;
        pt-BR:msg_sandbox_refresh_failed) printf "Aviso: não foi possível atualizar %s/easyxray.service.d/10-easyxray-sandbox.conf.\n" "$@" ;;
        pt-BR:msg_sandbox_write_hint) echo "Se EASYXRAY_DB_FOLDER ou EASYXRAY_LOG_FOLDER apontar para fora de /etc/easyxray e /var/log/easyxray, o painel pode não conseguir gravar nele sob ProtectSystem=full." ;;
        pt-BR:msg_checksum_none) echo "Nenhum checksum publicado para esta versão, ignorando a verificação" ;;
        pt-BR:msg_checksum_download_failed) printf "Falha ao baixar o checksum de %s (HTTP %s)\n" "$@" ;;
        pt-BR:msg_checksum_mismatch) printf "Checksum não corresponde para %s: esperado %s, obtido %s\n" "$@" ;;
        pt-BR:msg_checksum_ok) printf "Checksum verificado: %s\n" "$@" ;;
        pt-BR:msg_repo_file_missing) printf "%s não está disponível para %s (HTTP %s)\n" "$@" ;;
        pt-BR:msg_repo_file_missing_hint) echo "Instale uma versão que o inclua, ou 'dev' para a compilação contínua. Sua instalação existente não foi alterada." ;;
        pt-BR:msg_version_fetch_failed) echo "Falha ao obter a versão do easyxray, pode ser devido a restrições da API do GitHub; tente novamente mais tarde" ;;
        pt-BR:msg_latest_version) printf "Última versão do easyxray obtida: %s, iniciando a instalação...\n" "$@" ;;
        pt-BR:msg_download_failed) echo "Falha ao baixar o easyxray; verifique se o seu servidor consegue acessar o GitHub" ;;
        pt-BR:msg_archive_empty) echo "O arquivo da versão do easyxray baixado está vazio" ;;
        pt-BR:msg_dev_build) echo "Instalando a compilação contínua dev (tag: dev-latest). É uma pré-versão por commit, não uma versão estável." ;;
        pt-BR:msg_install_start) echo "Iniciando a instalação de" ;;
        pt-BR:msg_download_version_failed) printf "Falha ao baixar o easyxray %s; verifique se a versão existe\n" "$@" ;;
        pt-BR:msg_script_download_failed) echo "Falha ao baixar o easyxray.sh" ;;
        pt-BR:msg_script_empty) echo "O easyxray.sh baixado está vazio" ;;
        pt-BR:msg_bin_backup_failed) echo "Não foi possível fazer backup de bin/; os arquivos personalizados ali não serão preservados nesta atualização" ;;
        pt-BR:msg_extract_failed) echo "Falha ao extrair o arquivo da versão do easyxray; a instalação anterior já foi removida, então o painel não iniciará até que isso seja corrigido; tente executar o instalador novamente" ;;
        pt-BR:msg_binary_missing) echo "O arquivo extraído do easyxray não contém o binário easyxray; a instalação anterior já foi removida, então o painel não iniciará até que isso seja corrigido; tente executar o instalador novamente" ;;
        pt-BR:msg_bin_restored) printf "Arquivos personalizados em bin/ não fornecidos por esta versão foram restaurados: %s\n" "$@" ;;
        pt-BR:msg_script_install_failed) echo "Falha ao instalar o easyxray.sh" ;;
        pt-BR:msg_gitignore_added) echo "EasyXray.db adicionado a /etc/.gitignore para o etckeeper" ;;
        pt-BR:msg_gitignore_created) echo "/etc/.gitignore criado e EasyXray.db adicionado para o etckeeper" ;;
        pt-BR:msg_rc_download_failed) echo "Falha ao baixar o easyxray.rc" ;;
        pt-BR:msg_rc_empty) echo "O easyxray.rc baixado está vazio" ;;
        pt-BR:msg_rc_install_failed) echo "Falha ao instalar o easyxray.rc" ;;
        pt-BR:msg_service_found) echo "easyxray.service encontrado nos arquivos extraídos, instalando..." ;;
        pt-BR:msg_service_found_variant) printf "easyxray.service.%s encontrado nos arquivos extraídos, instalando...\n" "$@" ;;
        pt-BR:msg_service_downloading) echo "Arquivos de serviço não encontrados no tar.gz, baixando do GitHub..." ;;
        pt-BR:msg_service_install_failed) printf "Falha ao instalar o easyxray.service do GitHub (%s); o tarball da versão também não o incluía\n" "$@" ;;
        pt-BR:msg_systemd_setup) echo "Configurando a unidade do systemd..." ;;
        pt-BR:msg_service_file_failed) echo "Falha ao instalar o arquivo easyxray.service" ;;
        pt-BR:msg_installed_ok) echo "instalação concluída, já está em execução..." ;;
        pt-BR:msg_running) echo "Executando..." ;;
        pt-BR:msg_menu_admin) echo "Script de gerenciamento administrativo" ;;
        pt-BR:msg_menu_start) echo "Iniciar" ;;
        pt-BR:msg_menu_stop) echo "Parar" ;;
        pt-BR:msg_menu_restart) echo "Reiniciar" ;;
        pt-BR:msg_menu_status) echo "Status atual" ;;
        pt-BR:msg_menu_settings) echo "Configurações atuais" ;;
        pt-BR:msg_menu_enable) echo "Ativar a inicialização automática ao iniciar o sistema" ;;
        pt-BR:msg_menu_disable) echo "Desativar a inicialização automática ao iniciar o sistema" ;;
        pt-BR:msg_menu_log) echo "Verificar os logs" ;;
        pt-BR:msg_menu_banlog) echo "Verificar os logs de bloqueio do Fail2ban" ;;
        pt-BR:msg_menu_update) echo "Atualizar" ;;
        pt-BR:msg_menu_legacy) echo "Versão legada" ;;
        pt-BR:msg_menu_install) echo "Instalar" ;;
        pt-BR:msg_menu_uninstall) echo "Desinstalar" ;;
        # ---- en-US, and the fallback for every other locale ----
        *:msg_lang_menu_title) echo "Select installer language:" ;;
        *:msg_lang_invalid) echo "Invalid choice; keeping the current language." ;;
        *:msg_root_required) echo "Fatal error: Please run this script with root privilege" ;;
        *:msg_menu_title) echo "easyxray control menu usages (subcommands):" ;;
        *:msg_unsupported_arch) echo "Unsupported CPU architecture!" ;;
        *:msg_arch) printf "Arch: %s\n" "$@" ;;
        *:msg_os_check_failed) echo "Failed to check the system OS, please contact the author!" ;;
        *:msg_os_release) printf "The OS release is: %s\n" "$@" ;;
        *:msg_cert_not_pem) echo "certificate or private key is not a readable PEM file" ;;
        *:msg_cert_key_mismatch) echo "private key does not match the certificate" ;;
        *:msg_cert_file_unreadable) printf "certificate file is missing, empty or unreadable: %s\n" "$@" ;;
        *:msg_cert_key_unreadable) printf "private key file is missing, empty or unreadable: %s\n" "$@" ;;
        *:msg_cert_cli_failed) printf "easyxray cert exited %s: %s\n" "$@" ;;
        *:msg_cert_not_saved) printf "the panel did not save the certificate (stored cert=%s, key=%s)\n" "$@" ;;
        *:msg_result_write_failed) printf "Warning: failed to write %s.\n" "$@" ;;
        *:msg_result_written) printf "Install result written to %s (mode 600).\n" "$@" ;;
        *:msg_pg_pgdg_fallback) printf "PostgreSQL %s is not available for this system; installing the distribution's PostgreSQL instead.\n" "$@" ;;
        *:msg_pg_distro_unsupported) printf "Unsupported distro for automatic PostgreSQL install: %s\n" "$@" ;;
        *:msg_pg_hba_warn) echo "Warning: could not update pg_hba.conf; PostgreSQL may reject the panel's TCP login (ident auth)." ;;
        *:msg_pg_cred_write_failed) printf "Failed to write PostgreSQL credentials to %s\n" "$@" ;;
        *:msg_pg_client_tools) echo "Installing PostgreSQL client tools (pg_dump/pg_restore) for in-panel backup..." ;;
        *:msg_acme_installing_ssl) echo "Installing acme.sh for SSL certificate management..." ;;
        *:msg_acme_failed) echo "Failed to install acme.sh" ;;
        *:msg_acme_ok) echo "acme.sh installed successfully" ;;
        *:msg_ssl_setup_start) echo "Setting up SSL certificate..." ;;
        *:msg_acme_failed_skip) echo "Failed to install acme.sh, skipping SSL setup" ;;
        *:msg_ssl_issuing_domain) printf "Issuing SSL certificate for %s...\n" "$@" ;;
        *:msg_ssl_port80_note) echo "Note: Port 80 must be open and accessible from the internet" ;;
        *:msg_ssl_issue_failed) printf "Failed to issue certificate for %s\n" "$@" ;;
        *:msg_ssl_retry_hint) echo "Please ensure port 80 is open and try again later with: easyxray" ;;
        *:msg_ssl_install_failed) echo "Failed to install certificate" ;;
        *:msg_ssl_installed) echo "SSL certificate installed and configured successfully!" ;;
        *:msg_cert_files_not_found) echo "Certificate files not found" ;;
        *:msg_ipcert_setup) echo "Setting up Let's Encrypt IP certificate (shortlived profile)..." ;;
        *:msg_ipcert_validity_note) echo "Note: IP certificates are valid for ~6 days and will auto-renew." ;;
        *:msg_ipcert_port_note) echo "Default listener is port 80. If you choose another port, ensure external port 80 forwards to it." ;;
        *:msg_ipv4_required) echo "IPv4 address is required" ;;
        *:msg_ipv4_invalid) printf "Invalid IPv4 address: %s\n" "$@" ;;
        *:msg_ipv6_included) printf "Including IPv6 address: %s\n" "$@" ;;
        *:msg_acme_port_prompt) echo "Port to use for ACME HTTP-01 listener (default 80):" ;;
        *:msg_port_invalid_fallback) echo "Invalid port provided. Falling back to 80." ;;
        *:msg_port_using) printf "Using port %s for standalone validation.\n" "$@" ;;
        *:msg_port_forward_note) printf "Reminder: Let's Encrypt still connects on port 80; forward external port 80 to %s.\n" "$@" ;;
        *:msg_port_in_use) printf "Port %s is in use.\n" "$@" ;;
        *:msg_port_busy_ni) printf "Port %s is busy; cannot proceed in non-interactive mode.\n" "$@" ;;
        *:msg_acme_port_retry_prompt) echo "Enter another port for acme.sh standalone listener (leave empty to abort):" ;;
        *:msg_port_busy) printf "Port %s is busy; cannot proceed.\n" "$@" ;;
        *:msg_port_invalid) echo "Invalid port provided." ;;
        *:msg_port_free) printf "Port %s is free and ready for standalone validation.\n" "$@" ;;
        *:msg_ipcert_issuing) printf "Issuing IP certificate for %s...\n" "$@" ;;
        *:msg_ipcert_issue_failed) echo "Failed to issue IP certificate" ;;
        *:msg_ipcert_port_hint) printf "Please ensure port %s is reachable (or forwarded from external port 80)\n" "$@" ;;
        *:msg_cert_issued_installing) echo "Certificate issued successfully, installing..." ;;
        *:msg_cert_files_missing) echo "Certificate files not found after installation" ;;
        *:msg_cert_files_installed) echo "Certificate files installed successfully" ;;
        *:msg_cert_paths_setting) echo "Setting certificate paths for the panel..." ;;
        *:msg_cert_files_at) echo "Certificate files are at:" ;;
        *:msg_cert_file) echo "Certificate File:" ;;
        *:msg_cert_key) echo "Private Key File:" ;;
        *:msg_cert_paths_ok) echo "Certificate paths set for the panel" ;;
        *:msg_ipcert_installed) echo "IP certificate installed and configured successfully!" ;;
        *:msg_ipcert_autorenew) echo "Certificate valid for ~6 days, auto-renews via acme.sh cron job." ;;
        *:msg_acme_autorenew) echo "acme.sh will automatically renew and reload easyxray before expiry." ;;
        *:msg_acme_installing) echo "Installing acme.sh..." ;;
        *:msg_ssl_mode_needs_domain) printf "EASYXRAY_SSL_MODE=domain requires a valid EASYXRAY_DOMAIN (got: '%s').\n" "$@" ;;
        *:msg_domain_prompt) echo "Please enter your domain name: " ;;
        *:msg_domain_empty) echo "Domain name cannot be empty. Please try again." ;;
        *:msg_domain_invalid) echo "Invalid domain format. Please enter a valid domain name." ;;
        *:msg_domain_checking) printf "Your domain is: %s, checking it...\n" "$@" ;;
        *:msg_cert_existing_reuse) printf "Existing certificate found for %s, will reuse it.\n" "$@" ;;
        *:msg_acme_state_incomplete) printf "Found incomplete acme.sh state for %s (no valid certificate files); cleaning it up and re-issuing.\n" "$@" ;;
        *:msg_domain_ready) echo "Your domain is ready for issuing certificates now..." ;;
        *:msg_acme_port_choose_prompt) echo "Please choose which port to use (default is 80):" ;;
        *:msg_port_input_invalid) printf "Your input %s is invalid, will use default port 80.\n" "$@" ;;
        *:msg_port_will_use) printf "Will use port: %s to issue certificates. Please make sure this port is open.\n" "$@" ;;
        *:msg_panel_stopping) echo "Stopping panel temporarily..." ;;
        *:msg_cert_issue_failed_logs) echo "Issuing certificate failed, please check logs." ;;
        *:msg_cert_issue_succeeded) echo "Issuing certificate succeeded, installing certificates..." ;;
        *:msg_cert_using_existing) echo "Using existing certificate, installing certificates..." ;;
        *:msg_reloadcmd_default) echo "Default --reloadcmd for ACME is:" ;;
        *:msg_reloadcmd_runs_on) echo "This command will run on every certificate issue and renew." ;;
        *:msg_reloadcmd_modify_prompt) echo "Would you like to modify --reloadcmd for ACME? (y/n):" ;;
        *:msg_reloadcmd_preset) echo "Preset: systemctl reload nginx ; systemctl restart easyxray" ;;
        *:msg_reloadcmd_custom) echo "Input your own command" ;;
        *:msg_reloadcmd_keep_default) echo "Keep default reloadcmd" ;;
        *:msg_reloadcmd_option_prompt) echo "Choose an option:" ;;
        *:msg_reloadcmd_is_preset) echo "Reloadcmd is: systemctl reload nginx ; systemctl restart easyxray" ;;
        *:msg_reloadcmd_order) echo "It's recommended to put easyxray restart at the end" ;;
        *:msg_reloadcmd_custom_prompt) echo "Please enter your custom reloadcmd:" ;;
        *:msg_reloadcmd_is) printf "Reloadcmd is: %s\n" "$@" ;;
        *:msg_reloadcmd_keeping) echo "Keeping default reloadcmd" ;;
        *:msg_cert_installed_autorenew) echo "Installing certificate succeeded, enabling auto renew..." ;;
        *:msg_cert_install_failed_exit) echo "Installing certificate failed, exiting." ;;
        *:msg_autorenew_issues) echo "Auto renew setup had issues, certificate details:" ;;
        *:msg_autorenew_ok) echo "Auto renew succeeded, certificate details:" ;;
        *:msg_cert_set_panel_prompt) echo "Would you like to set this certificate for the panel? (y/n):" ;;
        *:msg_done_url) echo "Access URL:" ;;
        *:msg_cert_restart) echo "Panel will restart to apply SSL certificate..." ;;
        *:msg_cert_rejected) echo "Error: the panel refused the certificate, so the panel would serve plain HTTP." ;;
        *:msg_skip_panel_path) echo "Skipping panel path setting." ;;
        *:msg_ssl_choose) echo "Choose SSL certificate setup method:" ;;
        *:msg_ssl_opt1) echo "Let's Encrypt for Domain (90-day validity, auto-renews)" ;;
        *:msg_ssl_opt2) echo "Let's Encrypt for IP Address (6-day validity, auto-renews)" ;;
        *:msg_ssl_opt3) echo "Custom SSL Certificate (Path to existing files)" ;;
        *:msg_ssl_opt4) echo "Skip SSL (advanced - behind reverse proxy / SSH tunnel only)" ;;
        *:msg_ssl_note_opts) echo "Note: Options 1 & 2 require port 80 open. Option 3 requires manual paths." ;;
        *:msg_ssl_note_opt4) echo "Note: Option 4 serves the panel over plain HTTP — only safe behind nginx/Caddy or an SSH tunnel." ;;
        *:msg_ssl_mode_unknown) printf "Unknown EASYXRAY_SSL_MODE='%s', defaulting to none (HTTP).\n" "$@" ;;
        *:msg_ssl_pick) echo "Choose an option (default 2 for IP): " ;;
        *:msg_ssl_le_domain) echo "Using Let's Encrypt for domain certificate..." ;;
        *:msg_ssl_domain_ok) printf "✓ SSL certificate configured successfully with domain: %s\n" "$@" ;;
        *:msg_ssl_domain_extract_failed) echo "SSL setup may have completed, but domain extraction failed" ;;
        *:msg_ssl_domain_failed) echo "SSL certificate setup failed for domain mode." ;;
        *:msg_ssl_le_ip) echo "Using Let's Encrypt for IP certificate (shortlived profile)..." ;;
        *:msg_ipv4_confirm_prompt) printf "Is %s the correct incoming public IPv4 address for this server? [Default y]:\n" "$@" ;;
        *:msg_ipv4_prompt) echo "Please enter your server's public IPv4 address:" ;;
        *:msg_ipv4_invalid_retry) echo "Invalid IPv4 address. Please try again." ;;
        *:msg_ipv6_prompt) echo "Do you have an IPv6 address to include? (leave empty to skip):" ;;
        *:msg_ipcert_configured) echo "✓ Let's Encrypt IP certificate configured successfully" ;;
        *:msg_ipcert_setup_failed) echo "✗ IP certificate setup failed. Please check port 80 is open." ;;
        *:msg_custom_cert_using) echo "Using custom existing certificate..." ;;
        *:msg_custom_cert_domain_prompt) echo "Please enter domain name certificate issued for:" ;;
        *:msg_custom_cert_path_prompt) echo "Input certificate path (keywords: .crt / fullchain):" ;;
        *:msg_file_missing) echo "Error: File does not exist! Try again." ;;
        *:msg_file_unreadable) echo "Error: File exists but is not readable (check permissions)!" ;;
        *:msg_file_empty) echo "Error: File is empty!" ;;
        *:msg_custom_key_path_prompt) echo "Input private key path (keywords: .key / privatekey):" ;;
        *:msg_custom_cert_not_applied) echo "✗ Custom certificate was not applied -- the panel would serve plain HTTP." ;;
        *:msg_custom_cert_applied) echo "✓ Custom certificate paths applied." ;;
        *:msg_custom_cert_renew_note) echo "Note: You are responsible for renewing these files externally." ;;
        *:msg_no_ssl_title) echo "⚠ Panel will be installed WITHOUT SSL/TLS." ;;
        *:msg_no_ssl_plaintext) echo "Login credentials and cookies will travel as plain HTTP." ;;
        *:msg_no_ssl_safe_when) echo "Only safe when:" ;;
        *:msg_no_ssl_proxy) echo "  • A reverse proxy (nginx, Caddy, Traefik) terminates TLS for you, or" ;;
        *:msg_no_ssl_tunnel) echo "  • You access the panel exclusively via SSH tunnel" ;;
        *:msg_bind_localhost_prompt) echo "Bind the panel to 127.0.0.1 only? (recommended — forces SSH tunnel / reverse-proxy access) [y/N]:" ;;
        *:msg_panel_localhost_only) echo "✓ Panel bound to 127.0.0.1 only. It is now unreachable from the public internet." ;;
        *:msg_ssh_forward_title) echo "SSH Port Forwarding — open the panel from your local machine via:" ;;
        *:msg_ssh_cmd_standard) echo "  Standard SSH command:" ;;
        *:msg_ssh_cmd_key) echo "  If using an SSH key:" ;;
        *:msg_ssh_cmd_open) echo "  Then open in your browser:" ;;
        *:msg_ssh_alt_proxy) printf "Alternative: point a reverse proxy (nginx/Caddy) at 127.0.0.1:%s and let it terminate TLS.\n" "$@" ;;
        *:msg_no_ssl_all_interfaces) echo "Panel will listen on all interfaces over plain HTTP. Make sure something else is terminating TLS in front of it." ;;
        *:msg_ssl_skipped) echo "✓ SSL setup skipped." ;;
        *:msg_ssl_option_invalid) echo "Invalid option. Skipping SSL setup." ;;
        *:msg_ip_detect_failed) echo "Could not auto-detect server IP from any provider." ;;
        *:msg_db_selection_title) echo "Database Selection" ;;
        *:msg_db_opt_sqlite) echo "1) SQLite     (default — recommended for < 500 clients)" ;;
        *:msg_db_opt_pg) echo "2) PostgreSQL (recommended for high client counts / many nodes)" ;;
        *:msg_choose_default) echo "Choose [1]:" ;;
        *:msg_db_label_pg_external) echo "PostgreSQL (external)" ;;
        *:msg_pg_installing_local) echo "Installing PostgreSQL locally (non-interactive)..." ;;
        *:msg_pg_failed_ni) echo "PostgreSQL installation failed in non-interactive mode; aborting." ;;
        *:msg_pg_env_hint) echo "Set EASYXRAY_DB_DSN to use an existing server, or EASYXRAY_DB_TYPE=sqlite." ;;
        *:msg_pg_menu_local) echo "1) Install PostgreSQL locally and create a dedicated user/db (recommended)" ;;
        *:msg_pg_menu_external) echo "2) Use an existing PostgreSQL server (enter DSN)" ;;
        *:msg_pg_dsn_prompt) echo "Enter PostgreSQL DSN (postgres://user:pass@host:port/dbname?sslmode=disable):" ;;
        *:msg_pg_installing) echo "Installing PostgreSQL — this may take a moment..." ;;
        *:msg_pg_credfile_failed) echo "Failed to create temporary credentials file." ;;
        *:msg_pg_failed) echo "PostgreSQL installation failed." ;;
        *:msg_pg_menu_retry) echo "1) Retry local install" ;;
        *:msg_pg_menu_dsn) echo "2) Enter an external DSN instead" ;;
        *:msg_pg_menu_abort) echo "3) Abort install" ;;
        *:msg_pg_menu_fallback) echo "4) Fall back to SQLite" ;;
        *:msg_install_aborted) echo "Install aborted." ;;
        *:msg_pg_client_missing) echo "⚠ Could not install pg_dump/pg_restore. In-panel database backup/restore will be unavailable until you install the postgresql-client package." ;;
        *:msg_panel_port) printf "Your Panel Port is: %s\n" "$@" ;;
        *:msg_panel_port_random) printf "Generated random port: %s\n" "$@" ;;
        *:msg_panel_port_customize_prompt) echo "Would you like to customize the Panel Port settings? (If not, a random port will be applied) [y/n]:" ;;
        *:msg_panel_port_prompt) echo "Please set up the panel port:" ;;
        *:msg_ssl_title) echo "SSL Certificate Setup (RECOMMENDED)" ;;
        *:msg_ssl_recommend) echo "SSL is strongly recommended. Skip only if a reverse proxy or SSH tunnel handles TLS for you." ;;
        *:msg_ssl_le_note) echo "Let's Encrypt now supports both domains and IP addresses!" ;;
        *:msg_abort1) echo "The certificate could not be applied to the panel, so it would serve plain HTTP behind an https:// URL." ;;
        *:msg_abort2) echo "Nothing else was changed; fix the certificate and run the installer again." ;;
        *:msg_done_title) echo "Panel Installation Complete!" ;;
        *:msg_done_user) echo "Username:" ;;
        *:msg_done_pass) echo "Password:" ;;
        *:msg_done_port) echo "Port:" ;;
        *:msg_done_wbp) echo "WebBasePath:" ;;
        *:msg_done_db) echo "Database:" ;;
        *:msg_done_token) echo "API Token:" ;;
        *:msg_done_save) echo "IMPORTANT: Save these credentials securely!" ;;
        *:msg_ssl_on) echo "SSL Certificate: Enabled and configured" ;;
        *:msg_ssl_off) echo "SSL Certificate: Skipped - panel is HTTP-only. Use a reverse proxy or SSH tunnel." ;;
        *:msg_pg_backup_title) echo "PostgreSQL backup & restore is built into the panel:" ;;
        *:msg_pg_backup_menu) echo "→ Backup & Restore" ;;
        *:msg_pg_backup_note) echo "  Back Up downloads a pg_dump .dump file; Restore reloads it via pg_restore." ;;
        *:msg_pg_creds_title) echo "PostgreSQL Credentials" ;;
        *:msg_pg_db_name) echo "DB Name:" ;;
        *:msg_pg_username) echo "Username:" ;;
        *:msg_pg_password) echo "Password:" ;;
        *:msg_pg_host) echo "Host:" ;;
        *:msg_pg_port) echo "Port:" ;;
        *:msg_pg_dsn) echo "DSN:" ;;
        *:msg_pg_env_file) echo "Env file:" ;;
        *:msg_pg_connect) echo "Connect from this server:" ;;
        *:msg_pg_as_superuser) echo "(as the postgres superuser)" ;;
        *:msg_pg_env_read) printf "⚠ The panel reads these credentials from %s.\n" "$@" ;;
        *:msg_pg_save_password) echo "⚠ Save the password — it is not stored anywhere else in plain text." ;;
        *:msg_wbp_generating) echo "WebBasePath is missing or too short. Generating a new one..." ;;
        *:msg_wbp_new) printf "New WebBasePath: %s\n" "$@" ;;
        *:msg_default_creds) echo "Default credentials detected. Security update required..." ;;
        *:msg_new_creds) echo "Generated new random login credentials:" ;;
        *:msg_creds_set) echo "Username, Password, and WebBasePath are properly set." ;;
        *:msg_ssl_already_configured) echo "SSL certificate already configured. No action needed." ;;
        *:msg_f2b_skipped_env) printf "EASYXRAY_ENABLE_FAIL2BAN=%s, skipping Fail2ban auto-setup.\n" "$@" ;;
        *:msg_f2b_skipped_cli) echo "easyxray CLI not found; skipping Fail2ban auto-setup." ;;
        *:msg_f2b_skipped_old) echo "This easyxray.sh predates 'easyxray setup-fail2ban'; skipping Fail2ban auto-setup." ;;
        *:msg_f2b_setup) echo "Setting up Fail2ban for the IP Limit feature..." ;;
        *:msg_f2b_done) echo "Fail2ban setup complete." ;;
        *:msg_f2b_incomplete) echo "Fail2ban setup did not finish; IP Limit stays disabled until you run 'easyxray' and open the IP Limit menu. Continuing." ;;
        *:msg_systemd_hardening_note) printf "Note: systemd %s ignores part of the hardening in easyxray.service; the panel still starts.\n" "$@" ;;
        *:msg_systemd_hardening_missing) printf "      Not applied, needs a newer systemd: %s.\n" "$@" ;;
        *:msg_systemd_hardening_alias) echo "      The panel's folders stay writable through ReadWriteDirectories=, the alias this script installs." ;;
        *:msg_systemd_hardening_rest) echo "      The rest of the hardening is in force. Upgrade systemd to apply the above." ;;
        *:msg_ws_warn_head) echo "Warning: these folders contain whitespace and were left out of" ;;
        *:msg_ws_warn_detail) printf "         10-easyxray-sandbox.conf: %s\n" "$@" ;;
        *:msg_ws_warn_tail) echo "         The panel cannot write to them under the unit's sandbox." ;;
        *:msg_sandbox_refresh_failed) printf "Warning: could not refresh %s/easyxray.service.d/10-easyxray-sandbox.conf.\n" "$@" ;;
        *:msg_sandbox_write_hint) echo "If EASYXRAY_DB_FOLDER or EASYXRAY_LOG_FOLDER points outside /etc/easyxray and /var/log/easyxray, the panel may not be able to write to it under ProtectSystem=full." ;;
        *:msg_checksum_none) echo "No checksum published for this release, skipping verification" ;;
        *:msg_checksum_download_failed) printf "Failed to download the checksum for %s (HTTP %s)\n" "$@" ;;
        *:msg_checksum_mismatch) printf "Checksum mismatch for %s: expected %s, got %s\n" "$@" ;;
        *:msg_checksum_ok) printf "Checksum verified: %s\n" "$@" ;;
        *:msg_repo_file_missing) printf "%s is not available for %s (HTTP %s)\n" "$@" ;;
        *:msg_repo_file_missing_hint) echo "Install a release that ships it, or 'dev' for the rolling build. Your existing installation has not been touched." ;;
        *:msg_version_fetch_failed) echo "Failed to fetch easyxray version, it may be due to GitHub API restrictions, please try it later" ;;
        *:msg_latest_version) printf "Got easyxray latest version: %s, beginning the installation...\n" "$@" ;;
        *:msg_download_failed) echo "Downloading easyxray failed, please be sure that your server can access GitHub" ;;
        *:msg_archive_empty) echo "Downloaded easyxray release archive is empty" ;;
        *:msg_dev_build) echo "Installing the rolling dev build (tag: dev-latest). This is a per-commit pre-release, not a stable version." ;;
        *:msg_install_start) echo "Starting install of" ;;
        *:msg_download_version_failed) printf "Download easyxray %s failed, please check if the version exists\n" "$@" ;;
        *:msg_script_download_failed) echo "Failed to download easyxray.sh" ;;
        *:msg_script_empty) echo "Downloaded easyxray.sh is empty" ;;
        *:msg_bin_backup_failed) echo "Could not back up bin/ -- custom files there will not be preserved across this update" ;;
        *:msg_extract_failed) echo "Failed to extract the easyxray release archive -- the previous installation has already been removed, so the panel will not start until this is fixed; try running the installer again" ;;
        *:msg_binary_missing) echo "Extracted easyxray archive is missing the easyxray binary -- the previous installation has already been removed, so the panel will not start until this is fixed; try running the installer again" ;;
        *:msg_bin_restored) printf "Restored custom file(s) in bin/ not shipped by this release: %s\n" "$@" ;;
        *:msg_script_install_failed) echo "Failed to install easyxray.sh" ;;
        *:msg_gitignore_added) echo "Added EasyXray.db to /etc/.gitignore for etckeeper" ;;
        *:msg_gitignore_created) echo "Created /etc/.gitignore and added EasyXray.db for etckeeper" ;;
        *:msg_rc_download_failed) echo "Failed to download easyxray.rc" ;;
        *:msg_rc_empty) echo "Downloaded easyxray.rc is empty" ;;
        *:msg_rc_install_failed) echo "Failed to install easyxray.rc" ;;
        *:msg_service_found) echo "Found easyxray.service in extracted files, installing..." ;;
        *:msg_service_found_variant) printf "Found easyxray.service.%s in extracted files, installing...\n" "$@" ;;
        *:msg_service_downloading) echo "Service files not found in tar.gz, downloading from GitHub..." ;;
        *:msg_service_install_failed) printf "Failed to install easyxray.service from GitHub (%s) -- the release tarball did not ship one either\n" "$@" ;;
        *:msg_systemd_setup) echo "Setting up systemd unit..." ;;
        *:msg_service_file_failed) echo "Failed to install easyxray.service file" ;;
        *:msg_installed_ok) echo "installation finished, it is running now..." ;;
        *:msg_running) echo "Running..." ;;
        *:msg_menu_admin) echo "Admin Management Script" ;;
        *:msg_menu_start) echo "Start" ;;
        *:msg_menu_stop) echo "Stop" ;;
        *:msg_menu_restart) echo "Restart" ;;
        *:msg_menu_status) echo "Current Status" ;;
        *:msg_menu_settings) echo "Current Settings" ;;
        *:msg_menu_enable) echo "Enable Autostart on OS Startup" ;;
        *:msg_menu_disable) echo "Disable Autostart on OS Startup" ;;
        *:msg_menu_log) echo "Check logs" ;;
        *:msg_menu_banlog) echo "Check Fail2ban ban logs" ;;
        *:msg_menu_update) echo "Update" ;;
        *:msg_menu_legacy) echo "Legacy version" ;;
        *:msg_menu_install) echo "Install" ;;
        *:msg_menu_uninstall) echo "Uninstall" ;;
        *) echo "${__key}" ;;
    esac
}

# `;` separates the entries: a language name may contain a space ("Tiếng Việt").
install_locale_supported() {
    local locale
    local IFS=';'
    for locale in ${INSTALL_LANGUAGES}; do
        [[ "$1" == "${locale%%:*}" ]] && return 0
    done
    return 1
}

# Resolved before the first message goes out, so EASYXRAY_LANG reaches all of
# them; the menu below can still override it on a TTY.
resolve_install_language() {
    INSTALL_LANG="en-US"
    [[ -z "${EASYXRAY_LANG:-}" ]] && return 0
    if install_locale_supported "${EASYXRAY_LANG}"; then
        INSTALL_LANG="${EASYXRAY_LANG}"
    else
        echo -e "${yellow}$(msg msg_lang_invalid)${plain}" >&2
    fi
}
resolve_install_language

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}$(msg msg_root_required)${plain} \n " && exit 1

# Language menu, shown before anything is installed. It never runs unattended:
# `curl ... | bash` has no stdin to answer with, and EASYXRAY_LANG covers that.
select_install_language() {
    local choice entry index
    local IFS=';'
    [[ "$NONINTERACTIVE" == "1" ]] && return 0
    echo ""
    echo "$(msg msg_lang_menu_title)"
    index=1
    for entry in ${INSTALL_LANGUAGES}; do
        printf ' %2d) %s (%s)\n' "${index}" "${entry#*:}" "${entry%%:*}"
        index=$((index + 1))
    done
    read -rp "Language [${INSTALL_LANG}]: " choice
    choice="${choice// /}"
    [[ -z "${choice}" ]] && return 0
    index=1
    for entry in ${INSTALL_LANGUAGES}; do
        if [[ "${choice}" =~ ^[0-9]+$ ]] && ((10#${choice} == index)); then
            INSTALL_LANG="${entry%%:*}"
            return 0
        fi
        index=$((index + 1))
    done
    # An answer that names no row leaves the language the prompt advertised, so a
    # typo cannot discard an explicit EASYXRAY_LANG.
    echo -e "${yellow}$(msg msg_lang_invalid)${plain}"
}

# The box below is drawn at runtime: translated labels differ in width, and a
# CJK character takes two columns, so a fixed layout would not line up.
INSTALL_MENU_ROWS=(
    "easyxray|msg_menu_admin"
    "easyxray start|msg_menu_start"
    "easyxray stop|msg_menu_stop"
    "easyxray restart|msg_menu_restart"
    "easyxray status|msg_menu_status"
    "easyxray settings|msg_menu_settings"
    "easyxray enable|msg_menu_enable"
    "easyxray disable|msg_menu_disable"
    "easyxray log|msg_menu_log"
    "easyxray banlog|msg_menu_banlog"
    "easyxray update|msg_menu_update"
    "easyxray legacy|msg_menu_legacy"
    "easyxray install|msg_menu_install"
    "easyxray uninstall|msg_menu_uninstall"
)

# U+2000-U+2BFF is three bytes but one column: the box frame, arrows and
# warning signs live there, and counting them as wide breaks every alignment.
__NARROW3=$'\342[\200-\257][\200-\277]'

# Display columns, not bytes. wc -L varies by libc, so count UTF-8 lead bytes:
# 2-byte sequences are one column, 3- and 4-byte ones two unless __NARROW3.
display_width() {
    local __s="$1"
    local __bytes __two __three __four __narrow
    __bytes=$(printf '%s' "${__s}" | wc -c)
    __two=$(printf '%s' "${__s}" | LC_ALL=C tr -cd '\300-\337' | wc -c)
    __three=$(printf '%s' "${__s}" | LC_ALL=C tr -cd '\340-\357' | wc -c)
    __four=$(printf '%s' "${__s}" | LC_ALL=C tr -cd '\360-\364' | wc -c)
    __narrow=$(printf '%s' "${__s}" | LC_ALL=C grep -oaE "$__NARROW3" | wc -l)
    # __three already charged every three-byte character two columns, so a narrow
    # one -- a frame, an arrow, a Persian ZWNJ -- gives one of them back.
    echo $((__bytes - __two - __three - 2 * __four - __narrow))
}

print_usage_box() {
    local __row __cmd __label __pad __tail __rule __i
    local __title="$(msg msg_menu_title)"
    local __cmd_w=0 __label_w=0 __inner __w
    for __row in "${INSTALL_MENU_ROWS[@]}"; do
        __cmd="${__row%%|*}"
        __label="$(msg "${__row#*|}")"
        __w="$(display_width "${__cmd}")"
        if ((__w > __cmd_w)); then __cmd_w=${__w}; fi
        __w="$(display_width "${__label}")"
        if ((__w > __label_w)); then __label_w=${__w}; fi
    done
    __inner=$((__cmd_w + __label_w + 7))
    __w=$((4 + $(display_width "${__title}")))
    if ((__w > __inner)); then __inner=${__w}; fi
    for ((__i = 0; __i < __inner; __i++)); do __rule+="─"; done
    echo -e "${green}┌${__rule}┐${plain}"
    __tail="$(printf '%*s' "$((__inner - 2 - $(display_width "${__title}")))" '')"
    echo -e "│  ${blue}${__title}${plain}${__tail}│"
    echo -e "│$(printf '%*s' "${__inner}" '')│"
    for __row in "${INSTALL_MENU_ROWS[@]}"; do
        __cmd="${__row%%|*}"
        __label="$(msg "${__row#*|}")"
        __pad="$(printf '%*s' "$((__cmd_w - $(display_width "${__cmd}")))" '')"
        # Every row ends two columns inside the frame: the row's own overhead is
        # the bar, two spaces, the padded command, " - " and the closing bar.
        __tail="$(printf '%*s' "$((__inner - __cmd_w - 5 - $(display_width "${__label}")))" '')"
        echo -e "│  ${blue}${__cmd}${plain}${__pad} - ${__label}${__tail}│"
    done
    echo -e "${green}└${__rule}┘${plain}"
}


arch() {
    case "$(uname -m)" in
        x86_64 | x64 | amd64) echo 'amd64' ;;
        i*86 | x86) echo '386' ;;
        armv8* | armv8 | arm64 | aarch64) echo 'arm64' ;;
        armv7* | armv7 | arm) echo 'armv7' ;;
        armv6* | armv6) echo 'armv6' ;;
        armv5* | armv5) echo 'armv5' ;;
        s390x) echo 's390x' ;;
        *) echo -e "${green}$(msg msg_unsupported_arch) ${plain}" && rm -f "$(realpath "$0")" && exit 1 ;;
    esac
}

# Non-interactive mode: triggered explicitly via EASYXRAY_NONINTERACTIVE=1, or
# implicitly when stdin is not a TTY (e.g. `curl ... | bash`, cloud-init).
# In this mode every prompt below is replaced by an env var or a sane default.
if [[ "${EASYXRAY_NONINTERACTIVE:-0}" == "1" ]] || [[ ! -t 0 ]]; then
    NONINTERACTIVE=1
else
    NONINTERACTIVE=0
fi
export NONINTERACTIVE
select_install_language

# After the menu, so the first line of output is in the chosen language.
echo "$(msg msg_arch "$(arch)")"

# Check OS and set release variable
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    release=$ID
elif [[ -f /usr/lib/os-release ]]; then
    source /usr/lib/os-release
    release=$ID
else
    echo "$(msg msg_os_check_failed)" >&2
    exit 1
fi
echo "$(msg msg_os_release "${release}")"
export INSTALL_LANG

# Simple helpers
is_ipv4() {
    [[ "$1" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] && return 0 || return 1
}
is_ipv6() {
    [[ "$1" =~ : ]] && return 0 || return 1
}
is_ip() {
    is_ipv4 "$1" || is_ipv6 "$1"
}
is_domain() {
    [[ "$1" =~ ^([A-Za-z0-9](-*[A-Za-z0-9])*\.)+(xn--[a-z0-9]{2,}|[A-Za-z]{2,})$ ]] && return 0 || return 1
}

# acme.sh's standalone server binds IPv4 by default; --listen-v6 makes it
# v6-only, which breaks HTTP-01 validation when the domain's A record points
# at this host's IPv4 (#4994). Only force IPv6 when the host has no global
# IPv4 address at all.
acme_listen_flag() {
    if ip -4 addr show scope global 2> /dev/null | grep -q "inet "; then
        echo ""
    else
        echo "--listen-v6"
    fi
}

# Port helpers
is_port_in_use() {
    local port="$1"
    if command -v ss > /dev/null 2>&1; then
        ss -ltn 2> /dev/null | awk -v p=":${port}$" '$4 ~ p {exit 0} END {exit 1}'
        return
    fi
    if command -v netstat > /dev/null 2>&1; then
        netstat -lnt 2> /dev/null | awk -v p=":${port} " '$4 ~ p {exit 0} END {exit 1}'
        return
    fi
    if command -v lsof > /dev/null 2>&1; then
        lsof -nP -iTCP:${port} -sTCP:LISTEN > /dev/null 2>&1 && return 0
    fi
    return 1
}

# verify_panel_cert <cert> <key>
# The panel serves HTTPS only when both files parse as a matching X509 pair
# (internal/web/web.go); anything else makes it log an error and fall back to
# HTTP. Check that here instead of discovering it after the install.
verify_panel_cert() {
    local cert="$1" key="$2"
    local cert_pub key_pub
    # -modulus reads RSA only, so it rejected acme.sh's default ec-256 pair;
    # public keys compare alike for RSA, ECDSA and Ed25519. stdin is closed so
    # an encrypted key fails instead of stopping to ask for its passphrase.
    cert_pub=$(openssl x509 -noout -pubkey -in "$cert" 2> /dev/null)
    key_pub=$(openssl pkey -pubout -in "$key" < /dev/null 2> /dev/null)
    if [[ -z "$cert_pub" || -z "$key_pub" ]]; then
        echo "$(msg msg_cert_not_pem)"
        return 1
    fi
    if [[ "$cert_pub" != "$key_pub" ]]; then
        echo "$(msg msg_cert_key_mismatch)"
        return 1
    fi
    return 0
}

# apply_panel_cert <cert> <key>
# `easyxray cert` prints its failures but still exits 0 (main.go updateCert), so
# an unchecked call reports success while the panel keeps serving HTTP. Call it,
# then read the paths back to prove they reached the DB the panel reads.
apply_panel_cert() {
    local cert="$1" key="$2"
    local err="" out rc stored_cert stored_key attempt
    if [[ ! -s "$cert" || ! -r "$cert" ]]; then
        err="$(msg msg_cert_file_unreadable "${cert}")"
    elif [[ ! -s "$key" || ! -r "$key" ]]; then
        err="$(msg msg_cert_key_unreadable "${key}")"
    elif ! err=$(verify_panel_cert "$cert" "$key"); then
        :
    else
        for attempt in 1 2; do
            out=$(${easyxray_folder}/easyxray cert -webCert "$cert" -webCertKey "$key" 2>&1)
            rc=$?
            if [[ $rc -ne 0 ]]; then
                err="$(msg msg_cert_cli_failed "${rc}" "$(echo "$out" | tr '\n' ' ')")"
            else
                stored_cert=$(${easyxray_folder}/easyxray setting -getCert 2> /dev/null | grep '^cert:' | awk -F': ' '{print $2}' | tr -d '[:space:]')
                stored_key=$(${easyxray_folder}/easyxray setting -getCert 2> /dev/null | grep '^key:' | awk -F': ' '{print $2}' | tr -d '[:space:]')
                if [[ "$stored_cert" == "$cert" && "$stored_key" == "$key" ]]; then
                    return 0
                fi
                err="$(msg msg_cert_not_saved "${stored_cert}" "${stored_key}")"
            fi
            [[ $attempt -eq 1 ]] && sleep 1
        done
    fi
    echo "${err}" >&2
    return 1
}

install_base() {
    case "${release}" in
        ubuntu | debian | armbian)
            apt-get update && apt-get install -y -q cron curl tar tzdata socat ca-certificates openssl
            ;;
        fedora | amzn | virtuozzo | rhel | almalinux | rocky | ol)
            dnf makecache -y && dnf install -y -q cronie curl tar tzdata socat ca-certificates openssl
            ;;
        centos)
            if [[ "${VERSION_ID}" =~ ^7 ]]; then
                yum makecache -y && yum install -y cronie curl tar tzdata socat ca-certificates openssl
            else
                dnf makecache -y && dnf install -y -q cronie curl tar tzdata socat ca-certificates openssl
            fi
            ;;
        arch | manjaro | parch)
            pacman -Sy --noconfirm cronie curl tar tzdata socat ca-certificates openssl
            ;;
        opensuse-tumbleweed | opensuse-leap)
            zypper refresh && zypper -q install -y cron curl tar timezone socat ca-certificates openssl
            ;;
        alpine)
            apk update && apk add dcron curl tar tzdata socat ca-certificates openssl
            ;;
        *)
            apt-get update && apt-get install -y -q cron curl tar tzdata socat ca-certificates openssl
            ;;
    esac
}

gen_random_string() {
    local length="$1"
    openssl rand -base64 $((length * 2)) \
        | tr -dc 'a-zA-Z0-9' \
        | head -c "$length"
}

# prompt_or_default VARNAME "prompt text" "default" [ENV_NAME]
# Interactive: read into VARNAME. Non-interactive: VARNAME = ${ENV_NAME:-default}.
# ENV_NAME defaults to VARNAME when omitted. Keeps every interactive prompt
# string byte-for-byte identical to the original `read -rp`.
prompt_or_default() {
    local __var="$1" __prompt="$2" __default="$3" __env="${4:-$1}"
    if [[ "$NONINTERACTIVE" == "1" ]]; then
        printf -v "$__var" '%s' "${!__env:-$__default}"
    else
        # shellcheck disable=SC2229
        read -rp "$__prompt" "$__var"
    fi
}

# write_install_result <user> <pass> <port> <webpath> <scheme> <host> <token> <dbtype>
# Persists a parseable, root-only credentials file consumed by cloud-init/MOTD.
# Values are written with printf '%q' so a pinned password/username containing
# spaces, quotes, $(...) or backticks is shell-escaped and the file stays safely
# source-able (consumers do '. install-result.env'). For the alphanumeric random
# values gen_random_string emits, %q is a no-op. This is a DIFFERENT file from the
# Postgres env file (/etc/default/easyxray).
write_install_result() {
    local u="$1" p="$2" port="$3" wbp="$4" scheme="$5" host="$6" token="$7" dbtype="$8"
    local result_file="/etc/easyxray/install-result.env"
    local url_host="${host:-SERVER_IP_UNKNOWN}"
    install -d -m 700 /etc/easyxray 2> /dev/null
    local prev_umask
    prev_umask=$(umask)
    umask 077
    if ! {
        printf 'EASYXRAY_USERNAME=%q\n' "$u"
        printf 'EASYXRAY_PASSWORD=%q\n' "$p"
        printf 'EASYXRAY_PANEL_PORT=%q\n' "$port"
        printf 'EASYXRAY_WEB_BASE_PATH=%q\n' "$wbp"
        printf 'EASYXRAY_ACCESS_URL=%q\n' "${scheme}://${url_host}:${port}/${wbp}"
        printf 'EASYXRAY_API_TOKEN=%q\n' "$token"
        printf 'EASYXRAY_DB_TYPE=%q\n' "$dbtype"
    } > "$result_file"; then
        umask "$prev_umask"
        echo -e "${yellow}$(msg msg_result_write_failed "${result_file}")${plain}" >&2
        return 1
    fi
    umask "$prev_umask"
    chmod 600 "$result_file" 2> /dev/null
    chown root:root "$result_file" 2> /dev/null || true
    echo -e "${green}$(msg msg_result_written "${result_file}")${plain}"
}

# RHEL-family initdb writes pg_hba.conf host rules with ident auth, which
# compares the OS username against the Postgres role and always rejects the
# randomly generated panel role over TCP (#5806). Prepend password-auth rules
# scoped to the panel database; first match wins, and md5 also accepts
# scram-sha-256-stored verifiers, so this works on every supported distro.
pg_ensure_hba_password_auth() {
    local pg_db="$1"
    local hba_file
    hba_file=$(sudo -u postgres psql -tAc 'SHOW hba_file' 2> /dev/null | tr -d '[:space:]')
    [[ -n "${hba_file}" && -f "${hba_file}" ]] || return 0
    grep -Eq "^host[[:space:]]+${pg_db}[[:space:]]" "${hba_file}" && return 0
    local tmp
    tmp=$(mktemp) || return 1
    {
        echo "# Added by EasyXray: allow password logins for the panel database."
        echo "host    ${pg_db}    all    127.0.0.1/32    md5"
        echo "host    ${pg_db}    all    ::1/128         md5"
        cat "${hba_file}"
    } > "${tmp}" || {
        rm -f "${tmp}"
        return 1
    }
    cat "${tmp}" > "${hba_file}" || {
        rm -f "${tmp}"
        return 1
    }
    rm -f "${tmp}"
    sudo -u postgres psql -tAc 'SELECT pg_reload_conf()' > /dev/null 2>&1 || true
}

# New installs get this PostgreSQL major from the official PGDG repository; distros or
# CPU architectures PGDG does not build for fall back to the distribution's own package.
PG_TARGET_MAJOR=18

pg_has_debian_cluster() {
    command -v pg_lsclusters > /dev/null 2>&1 && [[ -n "$(pg_lsclusters -h 2> /dev/null)" ]]
}

# Installs postgresql-${PG_TARGET_MAJOR} from apt.postgresql.org. On failure it removes the
# repository it added, so an unsupported release cannot break later `apt-get update` runs.
pg_apt_install_pgdg_server() {
    local list added_lists=()
    for list in /etc/apt/sources.list.d/pgdg.list /etc/apt/sources.list.d/pgdg.sources; do
        [[ -e "${list}" ]] || added_lists+=("${list}")
    done
    if apt-get install -y -q postgresql-common ca-certificates gnupg >&2 \
        && /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y >&2 \
        && apt-get install -y -q "postgresql-${PG_TARGET_MAJOR}" >&2; then
        return 0
    fi
    for list in "${added_lists[@]}"; do
        rm -f "${list}"
    done
    apt-get update >&2 || true
    echo -e "${yellow}$(msg msg_pg_pgdg_fallback "${PG_TARGET_MAJOR}")${plain}" >&2
    return 1
}

# Installs postgresql${PG_TARGET_MAJOR}-server from the PGDG yum repository (EL 8+ only); on
# failure it undoes the repository and module changes it made. The caller runs initdb.
pg_el_install_pgdg_server() {
    local elver
    elver=$(rpm -E %rhel 2> /dev/null)
    [[ "${elver}" =~ ^[0-9]+$ && "${elver}" -ge 8 ]] && command -v dnf > /dev/null 2>&1 || return 1
    [[ -f /var/lib/pgsql/data/PG_VERSION ]] && return 1
    local added_repo=false
    if ! rpm -q pgdg-redhat-repo > /dev/null 2>&1; then
        if dnf install -y -q "https://download.postgresql.org/pub/repos/yum/reporpms/EL-${elver}-$(uname -m)/pgdg-redhat-repo-latest.noarch.rpm" >&2; then
            added_repo=true
            dnf -qy module disable postgresql > /dev/null 2>&1 || true
        fi
    fi
    if rpm -q pgdg-redhat-repo > /dev/null 2>&1 \
        && dnf install -y -q "postgresql${PG_TARGET_MAJOR}-server" "postgresql${PG_TARGET_MAJOR}-contrib" >&2; then
        return 0
    fi
    if [[ "${added_repo}" == "true" ]]; then
        dnf -qy module reset postgresql > /dev/null 2>&1 || true
        dnf remove -y -q pgdg-redhat-repo >&2 || true
    fi
    echo -e "${yellow}$(msg msg_pg_pgdg_fallback "${PG_TARGET_MAJOR}")${plain}" >&2
    return 1
}

install_postgres_local() {
    local pg_user pg_pass
    pg_pass=$(gen_random_string 24)
    local pg_db="easyxray"
    local pg_host="127.0.0.1"
    local pg_port="5432"

    local pg_service="postgresql"
    case "${release}" in
        ubuntu | debian | armbian)
            apt-get update >&2 || return 1
            if pg_has_debian_cluster || ! pg_apt_install_pgdg_server; then
                apt-get install -y -q postgresql >&2 || return 1
            fi
            ;;
        fedora | amzn | virtuozzo | rhel | almalinux | rocky | ol | centos)
            if [[ "${release}" != "fedora" && "${release}" != "amzn" ]] && pg_el_install_pgdg_server; then
                pg_service="postgresql-${PG_TARGET_MAJOR}"
                [[ -f "/var/lib/pgsql/${PG_TARGET_MAJOR}/data/PG_VERSION" ]] \
                    || "/usr/pgsql-${PG_TARGET_MAJOR}/bin/postgresql-${PG_TARGET_MAJOR}-setup" initdb >&2 || return 1
            else
                if [[ "${release}" == "centos" && "${VERSION_ID}" =~ ^7 ]]; then
                    yum install -y postgresql-server postgresql-contrib >&2 || return 1
                else
                    dnf install -y -q postgresql-server postgresql-contrib >&2 || return 1
                fi
                [[ -d /var/lib/pgsql/data && -f /var/lib/pgsql/data/PG_VERSION ]] || postgresql-setup --initdb >&2 || return 1
            fi
            ;;
        arch | manjaro | parch)
            pacman -Sy --noconfirm postgresql >&2 || return 1
            if [[ ! -f /var/lib/postgres/data/PG_VERSION ]]; then
                sudo -u postgres initdb -D /var/lib/postgres/data >&2 || return 1
            fi
            ;;
        opensuse-tumbleweed | opensuse-leap)
            zypper -q install -y postgresql-server postgresql-contrib >&2 || return 1
            if [[ ! -f /var/lib/pgsql/data/PG_VERSION ]]; then
                install -d -o postgres -g postgres -m 700 /var/lib/pgsql/data >&2 || return 1
                su - postgres -c "initdb -D /var/lib/pgsql/data" >&2 || return 1
            fi
            ;;
        alpine)
            apk add --no-cache postgresql postgresql-contrib >&2 || return 1
            if [[ ! -f /var/lib/postgresql/data/PG_VERSION ]]; then
                /etc/init.d/postgresql setup >&2 || return 1
            fi
            rc-update add postgresql default >&2 2> /dev/null || true
            rc-service postgresql start >&2 || return 1
            ;;
        *)
            echo -e "${red}$(msg msg_pg_distro_unsupported "${release}")${plain}" >&2
            return 1
            ;;
    esac

    if [[ "${release}" != "alpine" ]]; then
        systemctl enable --now "${pg_service}" >&2 || return 1
    fi

    # Wait briefly for the server to accept connections.
    local i
    for i in 1 2 3 4 5; do
        sudo -u postgres psql -tAc 'SELECT 1' > /dev/null 2>&1 && break
        sleep 1
    done

    local existing_owner=""
    existing_owner=$(sudo -u postgres psql -tAc \
        "SELECT pg_catalog.pg_get_userbyid(datdba) FROM pg_database WHERE datname='${pg_db}'" 2> /dev/null \
        | tr -d '[:space:]')
    if [[ -n "${existing_owner}" && "${existing_owner}" != "postgres" ]]; then
        pg_user="${existing_owner}"
    else
        pg_user=$(gen_random_string 8)
    fi

    # Idempotent role/db creation. Identifiers are double-quoted because a
    # random username may start with a digit, which Postgres rejects unquoted.
    sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${pg_user}'" 2> /dev/null \
        | grep -q 1 \
        || sudo -u postgres psql -c "CREATE USER \"${pg_user}\" WITH PASSWORD '${pg_pass}';" >&2 || return 1

    sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${pg_db}'" 2> /dev/null \
        | grep -q 1 \
        || sudo -u postgres psql -c "CREATE DATABASE \"${pg_db}\" OWNER \"${pg_user}\";" >&2 || return 1

    sudo -u postgres psql -c "ALTER USER \"${pg_user}\" WITH PASSWORD '${pg_pass}';" >&2 || return 1

    pg_ensure_hba_password_auth "${pg_db}" \
        || echo -e "${yellow}$(msg msg_pg_hba_warn)${plain}" >&2

    local pg_pass_enc
    pg_pass_enc=$(printf '%s' "${pg_pass}" | sed -e 's/%/%25/g' -e 's/:/%3A/g' -e 's/@/%40/g' -e 's|/|%2F|g' -e 's/?/%3F/g' -e 's/#/%23/g')

    if [[ -n "${PG_CRED_FILE:-}" ]]; then
        local prev_umask
        prev_umask=$(umask)
        umask 077
        if ! cat > "${PG_CRED_FILE}" << EOF; then
PG_USER=${pg_user}
PG_PASS=${pg_pass}
PG_HOST=${pg_host}
PG_PORT=${pg_port}
PG_DB=${pg_db}
EOF
            umask "${prev_umask}"
            echo -e "${red}$(msg msg_pg_cred_write_failed "${PG_CRED_FILE}")${plain}" >&2
            return 1
        fi
        umask "${prev_umask}"
    fi

    echo "postgres://${pg_user}:${pg_pass_enc}@${pg_host}:${pg_port}/${pg_db}?sslmode=disable"
    return 0
}

ensure_pg_client() {
    if command -v pg_dump > /dev/null 2>&1 && command -v pg_restore > /dev/null 2>&1; then
        return 0
    fi
    echo -e "${yellow}$(msg msg_pg_client_tools)${plain}" >&2
    case "${release}" in
        ubuntu | debian | armbian)
            apt-get update >&2 && apt-get install -y -q postgresql-client >&2 || return 1
            ;;
        fedora | amzn | virtuozzo | rhel | almalinux | rocky | ol)
            dnf install -y -q postgresql >&2 || return 1
            ;;
        centos)
            if [[ "${VERSION_ID}" =~ ^7 ]]; then
                yum install -y postgresql >&2 || return 1
            else
                dnf install -y -q postgresql >&2 || return 1
            fi
            ;;
        arch | manjaro | parch)
            pacman -Sy --noconfirm postgresql >&2 || return 1
            ;;
        opensuse-tumbleweed | opensuse-leap)
            zypper -q install -y postgresql >&2 || return 1
            ;;
        alpine)
            apk add --no-cache postgresql-client >&2 || return 1
            ;;
        *)
            return 1
            ;;
    esac
    command -v pg_dump > /dev/null 2>&1 && command -v pg_restore > /dev/null 2>&1
}

install_acme() {
    echo -e "${green}$(msg msg_acme_installing_ssl)${plain}"
    cd ~ || return 1
    curl -s https://get.acme.sh | sh > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${red}$(msg msg_acme_failed)${plain}"
        return 1
    else
        echo -e "${green}$(msg msg_acme_ok)${plain}"
    fi
    return 0
}

setup_ssl_certificate() {
    local domain="$1"
    local server_ip="$2"
    local existing_port="$3"
    local existing_webBasePath="$4"

    echo -e "${green}$(msg msg_ssl_setup_start)${plain}"

    # Check if acme.sh is installed
    if ! command -v ~/.acme.sh/acme.sh &> /dev/null; then
        install_acme
        if [ $? -ne 0 ]; then
            echo -e "${yellow}$(msg msg_acme_failed_skip)${plain}"
            return 1
        fi
    fi

    # Create certificate directory
    local certPath="/root/cert/${domain}"
    mkdir -p "$certPath"

    # Issue certificate
    echo -e "${green}$(msg msg_ssl_issuing_domain "${domain}")${plain}"
    echo -e "${yellow}$(msg msg_ssl_port80_note)${plain}"

    ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt --force > /dev/null 2>&1
    ~/.acme.sh/acme.sh --issue -d ${domain} $(acme_listen_flag) --standalone --httpport 80 --force

    if [ $? -ne 0 ]; then
        echo -e "${yellow}$(msg msg_ssl_issue_failed "${domain}")${plain}"
        echo -e "${yellow}$(msg msg_ssl_retry_hint)${plain}"
        rm -rf ~/.acme.sh/${domain} ~/.acme.sh/${domain}_ecc 2> /dev/null
        rm -rf "$certPath" 2> /dev/null
        return 1
    fi

    # Install certificate
    ~/.acme.sh/acme.sh --installcert --force -d ${domain} \
        --key-file /root/cert/${domain}/privkey.pem \
        --fullchain-file /root/cert/${domain}/fullchain.pem \
        --reloadcmd "systemctl restart easyxray" > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        echo -e "${yellow}$(msg msg_ssl_install_failed)${plain}"
        return 1
    fi

    # Enable auto-renew
    ~/.acme.sh/acme.sh --upgrade --auto-upgrade > /dev/null 2>&1
    # Secure permissions: private key readable only by owner
    chmod 600 $certPath/privkey.pem 2> /dev/null
    chmod 644 $certPath/fullchain.pem 2> /dev/null

    # Set certificate for panel
    local webCertFile="/root/cert/${domain}/fullchain.pem"
    local webKeyFile="/root/cert/${domain}/privkey.pem"

    if apply_panel_cert "$webCertFile" "$webKeyFile"; then
        echo -e "${green}$(msg msg_ssl_installed)${plain}"
        return 0
    fi
    echo -e "${yellow}$(msg msg_cert_files_not_found)${plain}"
    return 1
}

# Issue Let's Encrypt IP certificate with shortlived profile (~6 days validity)
# Requires acme.sh and port 80 open for HTTP-01 challenge
setup_ip_certificate() {
    local ipv4="$1"
    local ipv6="$2" # optional

    echo -e "${green}$(msg msg_ipcert_setup)${plain}"
    echo -e "${yellow}$(msg msg_ipcert_validity_note)${plain}"
    echo -e "${yellow}$(msg msg_ipcert_port_note)${plain}"

    # Check for acme.sh
    if ! command -v ~/.acme.sh/acme.sh &> /dev/null; then
        install_acme
        if [ $? -ne 0 ]; then
            echo -e "${red}$(msg msg_acme_failed)${plain}"
            return 1
        fi
    fi

    # Validate IP address
    if [[ -z "$ipv4" ]]; then
        echo -e "${red}$(msg msg_ipv4_required)${plain}"
        return 1
    fi

    if ! is_ipv4 "$ipv4"; then
        echo -e "${red}$(msg msg_ipv4_invalid "$ipv4")${plain}"
        return 1
    fi

    # Create certificate directory
    local certDir="/root/cert/ip"
    mkdir -p "$certDir"

    # Build domain arguments
    local domain_args="-d ${ipv4}"
    if [[ -n "$ipv6" ]] && is_ipv6 "$ipv6"; then
        domain_args="${domain_args} -d ${ipv6}"
        echo -e "${green}$(msg msg_ipv6_included "${ipv6}")${plain}"
    fi

    # Set reload command for auto-renewal (add || true so it doesn't fail during first install)
    local reloadCmd="systemctl restart easyxray 2>/dev/null || rc-service easyxray restart 2>/dev/null || true"

    # Choose port for HTTP-01 listener (default 80, prompt override)
    local WebPort=""
    prompt_or_default WebPort "$(msg msg_acme_port_prompt) " "80" EASYXRAY_ACME_HTTP_PORT
    WebPort="${WebPort:-80}"
    if ! [[ "${WebPort}" =~ ^[0-9]+$ ]] || ((WebPort < 1 || WebPort > 65535)); then
        echo -e "${red}$(msg msg_port_invalid_fallback)${plain}"
        WebPort=80
    fi
    echo -e "${green}$(msg msg_port_using "${WebPort}")${plain}"
    if [[ "${WebPort}" -ne 80 ]]; then
        echo -e "${yellow}$(msg msg_port_forward_note "${WebPort}")${plain}"
    fi

    # Ensure chosen port is available
    while true; do
        if is_port_in_use "${WebPort}"; then
            echo -e "${yellow}$(msg msg_port_in_use "${WebPort}")${plain}"

            local alt_port=""
            if [[ "$NONINTERACTIVE" == "1" ]]; then
                echo -e "${red}$(msg msg_port_busy_ni "${WebPort}")${plain}"
                return 1
            fi
            read -rp "$(msg msg_acme_port_retry_prompt) " alt_port
            alt_port="${alt_port// /}"
            if [[ -z "${alt_port}" ]]; then
                echo -e "${red}$(msg msg_port_busy "${WebPort}")${plain}"
                return 1
            fi
            if ! [[ "${alt_port}" =~ ^[0-9]+$ ]] || ((alt_port < 1 || alt_port > 65535)); then
                echo -e "${red}$(msg msg_port_invalid)${plain}"
                return 1
            fi
            WebPort="${alt_port}"
            continue
        else
            echo -e "${green}$(msg msg_port_free "${WebPort}")${plain}"
            break
        fi
    done

    # Issue certificate with shortlived profile
    echo -e "${green}$(msg msg_ipcert_issuing "${ipv4}")${plain}"
    ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt --force > /dev/null 2>&1
    [[ -n "${EASYXRAY_ACME_EMAIL:-}" ]] && ~/.acme.sh/acme.sh --register-account -m "${EASYXRAY_ACME_EMAIL}" > /dev/null 2>&1

    ~/.acme.sh/acme.sh --issue \
        ${domain_args} \
        --standalone \
        --server letsencrypt \
        --certificate-profile shortlived \
        --days 6 \
        --httpport ${WebPort} \
        --force

    if [ $? -ne 0 ]; then
        echo -e "${red}$(msg msg_ipcert_issue_failed)${plain}"
        echo -e "${yellow}$(msg msg_ipcert_port_hint "${WebPort}")${plain}"
        # Cleanup acme.sh data for both IPv4 and IPv6 if specified
        rm -rf ~/.acme.sh/${ipv4} ~/.acme.sh/${ipv4}_ecc 2> /dev/null
        [[ -n "$ipv6" ]] && rm -rf ~/.acme.sh/${ipv6} ~/.acme.sh/${ipv6}_ecc 2> /dev/null
        rm -rf ${certDir} 2> /dev/null
        return 1
    fi

    echo -e "${green}$(msg msg_cert_issued_installing)${plain}"

    # Install certificate
    # Note: acme.sh may report "Reload error" and exit non-zero if reloadcmd fails,
    # but the cert files are still installed. We check for files instead of exit code.
    ~/.acme.sh/acme.sh --installcert --force -d ${ipv4} \
        --key-file "${certDir}/privkey.pem" \
        --fullchain-file "${certDir}/fullchain.pem" \
        --reloadcmd "${reloadCmd}" 2>&1 || true

    # Verify certificate files exist (don't rely on exit code - reloadcmd failure causes non-zero)
    if [[ ! -f "${certDir}/fullchain.pem" || ! -f "${certDir}/privkey.pem" ]]; then
        echo -e "${red}$(msg msg_cert_files_missing)${plain}"
        # Cleanup acme.sh data for both IPv4 and IPv6 if specified
        rm -rf ~/.acme.sh/${ipv4} ~/.acme.sh/${ipv4}_ecc 2> /dev/null
        [[ -n "$ipv6" ]] && rm -rf ~/.acme.sh/${ipv6} ~/.acme.sh/${ipv6}_ecc 2> /dev/null
        rm -rf ${certDir} 2> /dev/null
        return 1
    fi

    echo -e "${green}$(msg msg_cert_files_installed)${plain}"

    # Enable auto-upgrade for acme.sh (ensures cron job runs)
    ~/.acme.sh/acme.sh --upgrade --auto-upgrade > /dev/null 2>&1

    # Secure permissions: private key readable only by owner
    chmod 600 ${certDir}/privkey.pem 2> /dev/null
    chmod 644 ${certDir}/fullchain.pem 2> /dev/null

    # Configure panel to use the certificate
    echo -e "${green}$(msg msg_cert_paths_setting)${plain}"
    if ! apply_panel_cert "${certDir}/fullchain.pem" "${certDir}/privkey.pem"; then
        echo -e "${yellow}$(msg msg_cert_files_at)${plain}"
        echo -e "  $(msg msg_cert_file) ${certDir}/fullchain.pem"
        echo -e "  $(msg msg_cert_key) ${certDir}/privkey.pem"
        return 1
    fi
    echo -e "${green}$(msg msg_cert_paths_ok)${plain}"

    echo -e "${green}$(msg msg_ipcert_installed)${plain}"
    echo -e "${green}$(msg msg_ipcert_autorenew)${plain}"
    echo -e "${yellow}$(msg msg_acme_autorenew)${plain}"
    return 0
}

# Comprehensive manual SSL certificate issuance via acme.sh
ssl_cert_issue() {
    local existing_webBasePath=$(${easyxray_folder}/easyxray setting -show true | grep 'webBasePath:' | awk -F': ' '{print $2}' | tr -d '[:space:]' | sed 's#^/##')
    local existing_port=$(${easyxray_folder}/easyxray setting -show true | grep 'port:' | awk -F': ' '{print $2}' | tr -d '[:space:]')

    # check for acme.sh first
    if ! command -v ~/.acme.sh/acme.sh &> /dev/null; then
        echo "$(msg msg_acme_installing)"
        cd ~ || return 1
        curl -s https://get.acme.sh | sh
        if [ $? -ne 0 ]; then
            echo -e "${red}$(msg msg_acme_failed)${plain}"
            return 1
        else
            echo -e "${green}$(msg msg_acme_ok)${plain}"
        fi
    fi

    # get the domain here, and we need to verify it
    local domain=""
    if [[ "$NONINTERACTIVE" == "1" ]]; then
        domain="${EASYXRAY_DOMAIN// /}"
        if [[ -z "$domain" ]] || ! is_domain "$domain"; then
            echo -e "${red}$(msg msg_ssl_mode_needs_domain "${EASYXRAY_DOMAIN:-}")${plain}"
            return 1
        fi
    else
        while true; do
            read -rp "$(msg msg_domain_prompt)" domain
            domain="${domain// /}" # Trim whitespace

            if [[ -z "$domain" ]]; then
                echo -e "${red}$(msg msg_domain_empty)${plain}"
                continue
            fi

            if ! is_domain "$domain"; then
                echo -e "${red}$(msg msg_domain_invalid) (${domain})${plain}"
                continue
            fi

            break
        done
    fi
    echo -e "${green}$(msg msg_domain_checking "${domain}")${plain}"
    SSL_ISSUED_DOMAIN="${domain}"

    # detect existing certificate and reuse it only if its files are actually
    # present and non-empty. acme.sh stores ECC certs under ${domain}_ecc and RSA
    # certs under ${domain}; a failed issuance can leave a domain entry in --list
    # with no usable cert files, which must not be reused (it produces a 0-byte
    # fullchain.pem). Broken partial state is cleaned up so issuance can proceed.
    local cert_exists=0
    if ~/.acme.sh/acme.sh --list 2> /dev/null | awk '{print $1}' | grep -Fxq "${domain}"; then
        local acmeCertDir=""
        if [[ -s ~/.acme.sh/${domain}_ecc/fullchain.cer && -s ~/.acme.sh/${domain}_ecc/${domain}.key ]]; then
            acmeCertDir=~/.acme.sh/${domain}_ecc
        elif [[ -s ~/.acme.sh/${domain}/fullchain.cer && -s ~/.acme.sh/${domain}/${domain}.key ]]; then
            acmeCertDir=~/.acme.sh/${domain}
        fi
        if [[ -n "${acmeCertDir}" ]]; then
            cert_exists=1
            local certInfo=$(~/.acme.sh/acme.sh --list 2> /dev/null | grep -F "${domain}")
            echo -e "${yellow}$(msg msg_cert_existing_reuse "${domain}")${plain}"
            [[ -n "${certInfo}" ]] && echo "$certInfo"
        else
            echo -e "${yellow}$(msg msg_acme_state_incomplete "${domain}")${plain}"
            rm -rf ~/.acme.sh/${domain} ~/.acme.sh/${domain}_ecc
        fi
    fi
    if [[ ${cert_exists} -eq 0 ]]; then
        echo -e "${green}$(msg msg_domain_ready)${plain}"
    fi

    # create a directory for the certificate
    certPath="/root/cert/${domain}"
    if [ ! -d "$certPath" ]; then
        mkdir -p "$certPath"
    else
        rm -rf "$certPath"
        mkdir -p "$certPath"
    fi

    # get the port number for the standalone server
    local WebPort=80
    prompt_or_default WebPort "$(msg msg_acme_port_choose_prompt) " "80" EASYXRAY_ACME_HTTP_PORT
    if [[ -z ${WebPort} ]]; then
        WebPort=80
    elif [[ ! ${WebPort} =~ ^[1-9][0-9]*$ || ${WebPort} -gt 65535 ]]; then
        echo -e "${yellow}$(msg msg_port_input_invalid "${WebPort}")${plain}"
        WebPort=80
    fi
    echo -e "${green}$(msg msg_port_will_use "${WebPort}")${plain}"

    # Stop panel temporarily
    echo -e "${yellow}$(msg msg_panel_stopping)${plain}"
    systemctl stop easyxray 2> /dev/null || rc-service easyxray stop 2> /dev/null

    if [[ ${cert_exists} -eq 0 ]]; then
        # issue the certificate
        ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt --force
        [[ -n "${EASYXRAY_ACME_EMAIL:-}" ]] && ~/.acme.sh/acme.sh --register-account -m "${EASYXRAY_ACME_EMAIL}" > /dev/null 2>&1
        ~/.acme.sh/acme.sh --issue -d ${domain} $(acme_listen_flag) --standalone --httpport ${WebPort} --force
        if [ $? -ne 0 ]; then
            echo -e "${red}$(msg msg_cert_issue_failed_logs)${plain}"
            rm -rf ~/.acme.sh/${domain} ~/.acme.sh/${domain}_ecc
            systemctl start easyxray 2> /dev/null || rc-service easyxray start 2> /dev/null
            return 1
        else
            echo -e "${green}$(msg msg_cert_issue_succeeded)${plain}"
        fi
    else
        echo -e "${green}$(msg msg_cert_using_existing)${plain}"
    fi

    # Setup reload command
    reloadCmd="systemctl restart easyxray || rc-service easyxray restart"
    echo -e "${green}$(msg msg_reloadcmd_default) ${yellow}systemctl restart easyxray || rc-service easyxray restart${plain}"
    echo -e "${green}$(msg msg_reloadcmd_runs_on)${plain}"
    if [[ "$NONINTERACTIVE" == "1" ]]; then
        setReloadcmd="n"
    else
        read -rp "$(msg msg_reloadcmd_modify_prompt) " setReloadcmd
    fi
    if [[ "$setReloadcmd" == "y" || "$setReloadcmd" == "Y" ]]; then
        echo -e "\n${green}\t1.${plain} $(msg msg_reloadcmd_preset)"
        echo -e "${green}\t2.${plain} $(msg msg_reloadcmd_custom)"
        echo -e "${green}\t0.${plain} $(msg msg_reloadcmd_keep_default)"
        read -rp "$(msg msg_reloadcmd_option_prompt) " choice
        case "$choice" in
            1)
                echo -e "${green}$(msg msg_reloadcmd_is_preset)${plain}"
                reloadCmd="systemctl reload nginx ; systemctl restart easyxray"
                ;;
            2)
                echo -e "${yellow}$(msg msg_reloadcmd_order)${plain}"
                read -rp "$(msg msg_reloadcmd_custom_prompt) " reloadCmd
                echo -e "${green}$(msg msg_reloadcmd_is "${reloadCmd}")${plain}"
                ;;
            *)
                echo -e "${green}$(msg msg_reloadcmd_keeping)${plain}"
                ;;
        esac
    fi

    # install the certificate
    local installOutput=""
    installOutput=$(~/.acme.sh/acme.sh --installcert --force -d ${domain} \
        --key-file /root/cert/${domain}/privkey.pem \
        --fullchain-file /root/cert/${domain}/fullchain.pem --reloadcmd "${reloadCmd}" 2>&1)
    local installRc=$?
    echo "${installOutput}"

    local installWroteFiles=0
    if echo "${installOutput}" | grep -q "Installing key to:" && echo "${installOutput}" | grep -q "Installing full chain to:"; then
        installWroteFiles=1
    fi

    if [[ -f "/root/cert/${domain}/privkey.pem" && -f "/root/cert/${domain}/fullchain.pem" && (${installRc} -eq 0 || ${installWroteFiles} -eq 1) ]]; then
        echo -e "${green}$(msg msg_cert_installed_autorenew)${plain}"
    else
        echo -e "${red}$(msg msg_cert_install_failed_exit)${plain}"
        if [[ ${cert_exists} -eq 0 ]]; then
            rm -rf ~/.acme.sh/${domain} ~/.acme.sh/${domain}_ecc
        fi
        systemctl start easyxray 2> /dev/null || rc-service easyxray start 2> /dev/null
        return 1
    fi

    # enable auto-renew
    ~/.acme.sh/acme.sh --upgrade --auto-upgrade
    if [ $? -ne 0 ]; then
        echo -e "${yellow}$(msg msg_autorenew_issues)${plain}"
        ls -lah /root/cert/${domain}/
        # Secure permissions: private key readable only by owner
        chmod 600 $certPath/privkey.pem 2> /dev/null
        chmod 644 $certPath/fullchain.pem 2> /dev/null
    else
        echo -e "${green}$(msg msg_autorenew_ok)${plain}"
        ls -lah /root/cert/${domain}/
        # Secure permissions: private key readable only by owner
        chmod 600 $certPath/privkey.pem 2> /dev/null
        chmod 644 $certPath/fullchain.pem 2> /dev/null
    fi

    # start panel
    systemctl start easyxray 2> /dev/null || rc-service easyxray start 2> /dev/null

    # Prompt user to set panel paths after successful certificate installation
    if [[ "$NONINTERACTIVE" == "1" ]]; then
        setPanel="y"
    else
        read -rp "$(msg msg_cert_set_panel_prompt) " setPanel
    fi
    if [[ "$setPanel" == "y" || "$setPanel" == "Y" ]]; then
        local webCertFile="/root/cert/${domain}/fullchain.pem"
        local webKeyFile="/root/cert/${domain}/privkey.pem"

        if apply_panel_cert "$webCertFile" "$webKeyFile"; then
            echo -e "${green}$(msg msg_cert_paths_ok)${plain}"
            echo -e "${green}$(msg msg_cert_file) $webCertFile${plain}"
            echo -e "${green}$(msg msg_cert_key) $webKeyFile${plain}"
            echo ""
            echo -e "${green}$(msg msg_done_url) https://${domain}:${existing_port}/${existing_webBasePath}${plain}"
            # config_after_install runs before the unit is written on a fresh
            # install; there is nothing to restart yet and the start after it
            # picks the certificate up from the DB.
            if [[ -f "${easyxray_service}/easyxray.service" || -f /etc/init.d/easyxray ]]; then
                echo -e "${yellow}$(msg msg_cert_restart)${plain}"
                systemctl restart easyxray 2> /dev/null || rc-service easyxray restart 2> /dev/null
            fi
        else
            echo -e "${red}$(msg msg_cert_rejected) (${domain})${plain}"
            return 1
        fi
    else
        echo -e "${yellow}$(msg msg_skip_panel_path)${plain}"
    fi

    return 0
}

# Reusable interactive SSL setup (domain or IP)
# Sets global `SSL_HOST` to the chosen domain/IP for Access URL usage
prompt_and_setup_ssl() {
    local panel_port="$1"
    local web_base_path="$2"
    local server_ip="$3"

    local ssl_choice=""
    SSL_SCHEME="https"

    echo -e "${yellow}$(msg msg_ssl_choose)${plain}"
    echo -e "${green}1.${plain} $(msg msg_ssl_opt1)"
    echo -e "${green}2.${plain} $(msg msg_ssl_opt2)"
    echo -e "${green}3.${plain} $(msg msg_ssl_opt3)"
    echo -e "${green}4.${plain} $(msg msg_ssl_opt4)"
    echo -e "${blue}$(msg msg_ssl_note_opts)${plain}"
    echo -e "${blue}$(msg msg_ssl_note_opt4)${plain}"
    if [[ "$NONINTERACTIVE" == "1" ]]; then
        case "${EASYXRAY_SSL_MODE:-none}" in
            domain) ssl_choice="1" ;;
            ip) ssl_choice="2" ;;
            none | "") ssl_choice="4" ;;
            *)
                echo -e "${yellow}$(msg msg_ssl_mode_unknown "${EASYXRAY_SSL_MODE}")${plain}"
                ssl_choice="4"
                ;;
        esac
    else
        read -rp "$(msg msg_ssl_pick)" ssl_choice
        ssl_choice="${ssl_choice// /}" # Trim whitespace

        # Default to 2 (IP cert) if input is empty or invalid (not 1, 3 or 4)
        if [[ "$ssl_choice" != "1" && "$ssl_choice" != "3" && "$ssl_choice" != "4" ]]; then
            ssl_choice="2"
        fi
    fi

    case "$ssl_choice" in
        1)
            # User chose Let's Encrypt domain option
            echo -e "${green}$(msg msg_ssl_le_domain)${plain}"
            if ssl_cert_issue; then
                local cert_domain="${SSL_ISSUED_DOMAIN}"
                if [[ -z "${cert_domain}" ]]; then
                    cert_domain=$(~/.acme.sh/acme.sh --list 2> /dev/null | tail -1 | awk '{print $1}')
                fi

                if [[ -n "${cert_domain}" ]]; then
                    SSL_HOST="${cert_domain}"
                    echo -e "${green}$(msg msg_ssl_domain_ok "${cert_domain}")${plain}"
                else
                    echo -e "${yellow}$(msg msg_ssl_domain_extract_failed)${plain}"
                    SSL_HOST="${server_ip}"
                fi
            else
                echo -e "${red}$(msg msg_ssl_domain_failed)${plain}"
                SSL_HOST="${server_ip}"
                return 1
            fi
            ;;
        2)
            # User chose Let's Encrypt IP certificate option
            echo -e "${green}$(msg msg_ssl_le_ip)${plain}"

            # Confirm the auto-detected IP before issuing for it: with asymmetric
            # routing / multi-WAN the echo services can return a transit address.
            if [[ "$NONINTERACTIVE" != "1" ]]; then
                local ip_confirm=""
                read -rp "$(msg msg_ipv4_confirm_prompt "${server_ip}") " ip_confirm
                if [[ -n "$ip_confirm" && "$ip_confirm" != "y" && "$ip_confirm" != "Y" ]]; then
                    server_ip=""
                    while [[ -z "$server_ip" ]]; do
                        read -rp "$(msg msg_ipv4_prompt) " server_ip
                        server_ip="${server_ip// /}"
                        if [[ ! "$server_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                            echo -e "${red}$(msg msg_ipv4_invalid_retry)${plain}"
                            server_ip=""
                        fi
                    done
                fi
            fi

            # Ask for optional IPv6
            local ipv6_addr=""
            prompt_or_default ipv6_addr "$(msg msg_ipv6_prompt) " "" EASYXRAY_SSL_IPV6
            ipv6_addr="${ipv6_addr// /}" # Trim whitespace

            # Stop panel if running (port 80 needed)
            if [[ $release == "alpine" ]]; then
                rc-service easyxray stop > /dev/null 2>&1
            else
                systemctl stop easyxray > /dev/null 2>&1
            fi

            setup_ip_certificate "${server_ip}" "${ipv6_addr}"
            if [ $? -eq 0 ]; then
                SSL_HOST="${server_ip}"
                echo -e "${green}$(msg msg_ipcert_configured)${plain}"
            else
                echo -e "${red}$(msg msg_ipcert_setup_failed)${plain}"
                SSL_HOST="${server_ip}"
                return 1
            fi
            ;;
        3)
            # User chose Custom Paths (User Provided) option
            echo -e "${green}$(msg msg_custom_cert_using)${plain}"
            local custom_cert=""
            local custom_key=""
            local custom_domain=""

            # 3.1 Request Domain to compose Panel URL later
            read -rp "$(msg msg_custom_cert_domain_prompt) " custom_domain
            custom_domain="${custom_domain// /}" # Remove spaces

            # 3.2 Loop for Certificate Path
            while true; do
                read -rp "$(msg msg_custom_cert_path_prompt) " custom_cert
                # Strip quotes if present
                custom_cert=$(echo "$custom_cert" | tr -d '"' | tr -d "'")

                if [[ -f "$custom_cert" && -r "$custom_cert" && -s "$custom_cert" ]]; then
                    break
                elif [[ ! -f "$custom_cert" ]]; then
                    echo -e "${red}$(msg msg_file_missing)${plain}"
                elif [[ ! -r "$custom_cert" ]]; then
                    echo -e "${red}$(msg msg_file_unreadable)${plain}"
                else
                    echo -e "${red}$(msg msg_file_empty)${plain}"
                fi
            done

            # 3.3 Loop for Private Key Path
            while true; do
                read -rp "$(msg msg_custom_key_path_prompt) " custom_key
                # Strip quotes if present
                custom_key=$(echo "$custom_key" | tr -d '"' | tr -d "'")

                if [[ -f "$custom_key" && -r "$custom_key" && -s "$custom_key" ]]; then
                    break
                elif [[ ! -f "$custom_key" ]]; then
                    echo -e "${red}$(msg msg_file_missing)${plain}"
                elif [[ ! -r "$custom_key" ]]; then
                    echo -e "${red}$(msg msg_file_unreadable)${plain}"
                else
                    echo -e "${red}$(msg msg_file_empty)${plain}"
                fi
            done

            # 3.4 Apply Settings via easyxray binary
            if ! apply_panel_cert "$custom_cert" "$custom_key"; then
                echo -e "${red}$(msg msg_custom_cert_not_applied)${plain}"
                SSL_SCHEME="http"
                SSL_HOST="${server_ip}"
                return 1
            fi

            # Set SSL_HOST for composing Panel URL
            if [[ -n "$custom_domain" ]]; then
                SSL_HOST="$custom_domain"
            else
                SSL_HOST="${server_ip}"
            fi

            echo -e "${green}$(msg msg_custom_cert_applied)${plain}"
            echo -e "${yellow}$(msg msg_custom_cert_renew_note)${plain}"

            systemctl restart easyxray > /dev/null 2>&1 || rc-service easyxray restart > /dev/null 2>&1
            ;;
        4)
            echo ""
            echo -e "${red}$(msg msg_no_ssl_title)${plain}"
            echo -e "${yellow}$(msg msg_no_ssl_plaintext)${plain}"
            echo -e "${yellow}$(msg msg_no_ssl_safe_when)${plain}"
            echo -e "${yellow}$(msg msg_no_ssl_proxy)${plain}"
            echo -e "${yellow}$(msg msg_no_ssl_tunnel)${plain}"
            echo ""

            SSL_SCHEME="http"
            SSL_HOST="${server_ip}"

            local bind_local=""
            if [[ "$NONINTERACTIVE" == "1" ]]; then
                # Cloud images must stay reachable on their public interface.
                bind_local="n"
            else
                read -rp "$(msg msg_bind_localhost_prompt) " bind_local
            fi
            if [[ "$bind_local" == "y" || "$bind_local" == "Y" ]]; then
                ${easyxray_folder}/easyxray setting -listenIP "127.0.0.1" > /dev/null 2>&1
                SSL_HOST="127.0.0.1"
                echo -e "${green}$(msg msg_panel_localhost_only)${plain}"
                echo ""
                echo -e "${green}$(msg msg_ssh_forward_title)${plain}"
                echo -e "$(msg msg_ssh_cmd_standard)"
                echo -e "  ${yellow}ssh -L 2222:127.0.0.1:${panel_port} root@${server_ip}${plain}"
                echo -e "$(msg msg_ssh_cmd_key)"
                echo -e "  ${yellow}ssh -i <sshkeypath> -L 2222:127.0.0.1:${panel_port} root@${server_ip}${plain}"
                echo -e "$(msg msg_ssh_cmd_open)"
                echo -e "  ${yellow}http://localhost:2222/${web_base_path}${plain}"
                echo ""
                echo -e "${yellow}$(msg msg_ssh_alt_proxy "${panel_port}")${plain}"
            else
                echo -e "${yellow}$(msg msg_no_ssl_all_interfaces)${plain}"
            fi

            systemctl restart easyxray > /dev/null 2>&1 || rc-service easyxray restart > /dev/null 2>&1
            echo -e "${green}$(msg msg_ssl_skipped)${plain}"
            ;;
        *)
            echo -e "${red}$(msg msg_ssl_option_invalid)${plain}"
            SSL_HOST="${server_ip}"
            ;;
    esac
}

config_after_install() {
    local existing_hasDefaultCredential=$(${easyxray_folder}/easyxray setting -show true | grep -Eo 'hasDefaultCredential: .+' | awk '{print $2}')
    local existing_webBasePath=$(${easyxray_folder}/easyxray setting -show true | grep -Eo 'webBasePath: .+' | awk '{print $2}' | sed 's#^/##')
    local existing_port=$(${easyxray_folder}/easyxray setting -show true | grep -Eo 'port: .+' | awk '{print $2}')
    # Properly detect empty cert by checking if cert: line exists and has content after it
    local existing_cert=$(${easyxray_folder}/easyxray setting -getCert true | grep 'cert:' | awk -F': ' '{print $2}' | tr -d '[:space:]')
    local URL_lists=(
        "https://api4.ipify.org"
        "https://ipv4.icanhazip.com"
        "https://v4.api.ipinfo.io/ip"
        "https://ipv4.myexternalip.com/raw"
        "https://4.ident.me"
        "https://check-host.net/ip"
    )
    local server_ip=""
    for ip_address in "${URL_lists[@]}"; do
        local response=$(curl -s -w "\n%{http_code}" --max-time 3 "${ip_address}" 2> /dev/null)
        local http_code=$(echo "$response" | tail -n1)
        local ip_result=$(echo "$response" | head -n-1 | tr -d '[:space:]"')
        if [[ "${http_code}" == "200" && "${ip_result}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            server_ip="${ip_result}"
            break
        fi
    done

    if [[ -z "$server_ip" ]]; then
        if [[ "$NONINTERACTIVE" == "1" ]]; then
            # Panel binds 0.0.0.0 regardless; the IP is only used to compose the
            # displayed access URL. Fall back to EASYXRAY_SERVER_IP or leave blank.
            server_ip="${EASYXRAY_SERVER_IP:-}"
        else
            echo -e "${yellow}$(msg msg_ip_detect_failed)${plain}"
            while [[ -z "$server_ip" ]]; do
                read -rp "$(msg msg_ipv4_prompt) " server_ip
                server_ip="${server_ip// /}"
                if [[ ! "$server_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                    echo -e "${red}$(msg msg_ipv4_invalid_retry)${plain}"
                    server_ip=""
                fi
            done
        fi
    fi

    if [[ ${#existing_webBasePath} -lt 4 ]]; then
        if [[ "$existing_hasDefaultCredential" == "true" ]]; then
            local config_webBasePath="${EASYXRAY_WEB_BASE_PATH:-$(gen_random_string 18)}"
            local config_username="${EASYXRAY_USERNAME:-$(gen_random_string 10)}"
            local config_password="${EASYXRAY_PASSWORD:-$(gen_random_string 10)}"
            local config_port=""

            local db_label="SQLite (/etc/easyxray/EasyXray.db)"
            echo ""
            echo -e "${green}═══════════════════════════════════════════${plain}"
            echo -e "${green}     $(msg msg_db_selection_title)${plain}"
            echo -e "${green}═══════════════════════════════════════════${plain}"
            echo -e "  $(msg msg_db_opt_sqlite)"
            echo -e "  $(msg msg_db_opt_pg)"
            if [[ "$NONINTERACTIVE" == "1" ]]; then
                if [[ "${EASYXRAY_DB_TYPE:-sqlite}" == "postgres" ]]; then
                    db_choice="2"
                else
                    db_choice="1"
                fi
            else
                read -rp "$(msg msg_choose_default) " db_choice
                db_choice="${db_choice:-1}"
            fi
            if [[ "$db_choice" == "2" ]]; then
                local easyxray_env_file
                case "${release}" in
                    ubuntu | debian | armbian)
                        easyxray_env_file="/etc/default/easyxray"
                        ;;
                    arch | manjaro | parch | alpine)
                        easyxray_env_file="/etc/conf.d/easyxray"
                        ;;
                    *)
                        easyxray_env_file="/etc/sysconfig/easyxray"
                        ;;
                esac

                local easyxray_dsn=""
                local pg_mode=""
                local pg_local_installed=0
                while [[ -z "$easyxray_dsn" ]]; do
                    if [[ "$NONINTERACTIVE" == "1" ]]; then
                        if [[ -n "${EASYXRAY_DB_DSN:-}" ]]; then
                            easyxray_dsn="${EASYXRAY_DB_DSN}"
                            db_label="$(msg msg_db_label_pg_external)"
                            break
                        fi
                        echo -e "${yellow}$(msg msg_pg_installing_local)${plain}"
                        local pg_cred_file
                        pg_cred_file=$(mktemp 2> /dev/null) || pg_cred_file=$(mktemp -t easyxray-pg-creds.XXXXXXXX)
                        if [[ -n "${pg_cred_file}" ]] && easyxray_dsn=$(PG_CRED_FILE="${pg_cred_file}" install_postgres_local); then
                            pg_local_installed=1
                            if [[ -r "${pg_cred_file}" ]]; then
                                # shellcheck disable=SC1090
                                source "${pg_cred_file}"
                            fi
                            rm -f "${pg_cred_file}"
                            db_label="PostgreSQL (${PG_USER}@${PG_HOST}:${PG_PORT}/${PG_DB})"
                            break
                        fi
                        rm -f "${pg_cred_file}"
                        echo -e "${red}$(msg msg_pg_failed_ni)${plain}"
                        echo -e "${yellow}$(msg msg_pg_env_hint)${plain}"
                        exit 1
                    fi
                    echo ""
                    echo -e "  $(msg msg_pg_menu_local)"
                    echo -e "  $(msg msg_pg_menu_external)"
                    read -rp "$(msg msg_choose_default) " pg_mode
                    pg_mode="${pg_mode:-1}"
                    if [[ "$pg_mode" == "2" ]]; then
                        while [[ -z "$easyxray_dsn" ]]; do
                            read -rp "$(msg msg_pg_dsn_prompt) " easyxray_dsn
                            easyxray_dsn="${easyxray_dsn// /}"
                        done
                        db_label="$(msg msg_db_label_pg_external)"
                    else
                        echo -e "${yellow}$(msg msg_pg_installing)${plain}"
                        local pg_cred_file
                        pg_cred_file=$(mktemp 2> /dev/null) || pg_cred_file=$(mktemp -t easyxray-pg-creds.XXXXXXXX)
                        if [[ -z "${pg_cred_file}" ]]; then
                            echo -e "${red}$(msg msg_pg_credfile_failed)${plain}"
                            easyxray_dsn=""
                            continue
                        fi
                        if easyxray_dsn=$(PG_CRED_FILE="${pg_cred_file}" install_postgres_local); then
                            pg_local_installed=1
                            if [[ -r "${pg_cred_file}" ]]; then
                                # shellcheck disable=SC1090
                                source "${pg_cred_file}"
                            fi
                            rm -f "${pg_cred_file}"
                            db_label="PostgreSQL (${PG_USER}@${PG_HOST}:${PG_PORT}/${PG_DB})"
                        else
                            rm -f "${pg_cred_file}"
                            echo ""
                            echo -e "${red}$(msg msg_pg_failed)${plain}"
                            echo -e "  $(msg msg_pg_menu_retry)"
                            echo -e "  $(msg msg_pg_menu_dsn)"
                            echo -e "  $(msg msg_pg_menu_abort)"
                            echo -e "  $(msg msg_pg_menu_fallback)"
                            read -rp "$(msg msg_choose_default) " pg_fail
                            pg_fail="${pg_fail:-1}"
                            case "$pg_fail" in
                                2) pg_mode="2" ;;
                                3)
                                    echo -e "${red}$(msg msg_install_aborted)${plain}"
                                    exit 1
                                    ;;
                                4)
                                    db_choice="1"
                                    easyxray_dsn=""
                                    break
                                    ;;
                                *) easyxray_dsn="" ;;
                            esac
                        fi
                    fi
                done
                if [[ -n "$easyxray_dsn" ]]; then
                    install -d -m 755 "$(dirname "$easyxray_env_file")"
                    umask 077
                    cat > "$easyxray_env_file" << EOF
EASYXRAY_DB_TYPE=postgres
EASYXRAY_DB_DSN=${easyxray_dsn}
EOF
                    chmod 600 "$easyxray_env_file"
                    umask 022
                    export EASYXRAY_DB_TYPE=postgres
                    export EASYXRAY_DB_DSN="${easyxray_dsn}"
                    ensure_pg_client || echo -e "${yellow}$(msg msg_pg_client_missing)${plain}"
                fi
            fi

            if [[ "$NONINTERACTIVE" == "1" ]]; then
                if [[ -n "${EASYXRAY_PANEL_PORT:-}" ]]; then
                    config_port="${EASYXRAY_PANEL_PORT}"
                    echo -e "${yellow}$(msg msg_panel_port "${config_port}")${plain}"
                else
                    config_port=$(shuf -i 1024-62000 -n 1)
                    echo -e "${yellow}$(msg msg_panel_port_random "${config_port}")${plain}"
                fi
            else
                read -rp "$(msg msg_panel_port_customize_prompt) " config_confirm
                if [[ "${config_confirm}" == "y" || "${config_confirm}" == "Y" ]]; then
                    read -rp "$(msg msg_panel_port_prompt) " config_port
                    echo -e "${yellow}$(msg msg_panel_port "${config_port}")${plain}"
                else
                    config_port=$(shuf -i 1024-62000 -n 1)
                    echo -e "${yellow}$(msg msg_panel_port_random "${config_port}")${plain}"
                fi
            fi

            ${easyxray_folder}/easyxray setting -username "${config_username}" -password "${config_password}" -port "${config_port}" -webBasePath "${config_webBasePath}"

            echo ""
            echo -e "${green}═══════════════════════════════════════════${plain}"
            echo -e "${green}     $(msg msg_ssl_title)${plain}"
            echo -e "${green}═══════════════════════════════════════════${plain}"
            echo -e "${yellow}$(msg msg_ssl_recommend)${plain}"
            echo -e "${yellow}$(msg msg_ssl_le_note)${plain}"
            echo ""

            if ! prompt_and_setup_ssl "${config_port}" "${config_webBasePath}" "${server_ip}"; then
                echo -e "${red}$(msg msg_abort1)${plain}"
                echo -e "${red}$(msg msg_abort2)${plain}"
                exit 1
            fi

            # Retrieve the API token for display
            local config_apiToken=$(${easyxray_folder}/easyxray setting -getApiToken | grep -Eo 'apiToken: .+' | awk '{print $2}')

            # Display final credentials and access information
            echo ""
            echo -e "${green}═══════════════════════════════════════════${plain}"
            echo -e "${green}     $(msg msg_done_title)${plain}"
            echo -e "${green}═══════════════════════════════════════════${plain}"
            echo -e "${green}$(msg msg_done_user) ${config_username}${plain}"
            echo -e "${green}$(msg msg_done_pass) ${config_password}${plain}"
            echo -e "${green}$(msg msg_done_port) ${config_port}${plain}"
            echo -e "${green}$(msg msg_done_wbp) ${config_webBasePath}${plain}"
            echo -e "${green}$(msg msg_done_db) ${db_label}${plain}"
            echo -e "${green}$(msg msg_done_url) ${SSL_SCHEME}://${SSL_HOST}:${config_port}/${config_webBasePath}${plain}"
            echo -e "${green}$(msg msg_done_token) ${config_apiToken}${plain}"
            echo -e "${green}═══════════════════════════════════════════${plain}"
            echo -e "${yellow}⚠ $(msg msg_done_save)${plain}"
            if [[ "$SSL_SCHEME" == "https" ]]; then
                echo -e "${yellow}⚠ $(msg msg_ssl_on)${plain}"
            else
                echo -e "${yellow}⚠ $(msg msg_ssl_off)${plain}"
            fi

            if [[ "$db_choice" == "2" ]]; then
                echo ""
                echo -e "${green}$(msg msg_pg_backup_title)${plain}"
                echo -e "  ${blue}${SSL_SCHEME}://${SSL_HOST}:${config_port}/${config_webBasePath}${plain} $(msg msg_pg_backup_menu)"
                echo -e "${yellow}$(msg msg_pg_backup_note)${plain}"
            fi

            if [[ "$db_choice" == "2" && "$pg_local_installed" == "1" ]]; then
                echo ""
                echo -e "${green}═══════════════════════════════════════════${plain}"
                echo -e "${green}     $(msg msg_pg_creds_title)${plain}"
                echo -e "${green}═══════════════════════════════════════════${plain}"
                echo -e "${green}$(msg msg_pg_db_name) ${PG_DB}${plain}"
                echo -e "${green}$(msg msg_pg_username) ${PG_USER}${plain}"
                echo -e "${green}$(msg msg_pg_password) ${PG_PASS}${plain}"
                echo -e "${green}$(msg msg_pg_host) ${PG_HOST}${plain}"
                echo -e "${green}$(msg msg_pg_port) ${PG_PORT}${plain}"
                echo -e "${green}$(msg msg_pg_dsn) ${easyxray_dsn}${plain}"
                echo -e "${green}$(msg msg_pg_env_file) ${easyxray_env_file}${plain}"
                echo -e "${green}-------------------------------------------${plain}"
                echo -e "${green}$(msg msg_pg_connect)${plain}"
                echo -e "  ${blue}sudo -u postgres psql -d ${PG_DB}${plain}      $(msg msg_pg_as_superuser)"
                echo -e "  ${blue}PGPASSWORD='${PG_PASS}' psql -h ${PG_HOST} -p ${PG_PORT} -U ${PG_USER} -d ${PG_DB}${plain}"
                echo -e "${green}═══════════════════════════════════════════${plain}"
                echo -e "${yellow}$(msg msg_pg_env_read "${easyxray_env_file}")${plain}"
                echo -e "${yellow}$(msg msg_pg_save_password)${plain}"
                unset PG_USER PG_PASS PG_HOST PG_PORT PG_DB
            fi

            # Persist a machine-parseable credentials file for cloud-init / MOTD.
            : "${SSL_SCHEME:=https}"
            : "${SSL_HOST:=${server_ip}}"
            local db_type_out="sqlite"
            [[ "$db_choice" == "2" ]] && db_type_out="postgres"
            write_install_result "${config_username}" "${config_password}" "${config_port}" \
                "${config_webBasePath}" "${SSL_SCHEME}" "${SSL_HOST}" "${config_apiToken}" "${db_type_out}"
        else
            local config_webBasePath=$(gen_random_string 18)
            echo -e "${yellow}$(msg msg_wbp_generating)${plain}"
            ${easyxray_folder}/easyxray setting -webBasePath "${config_webBasePath}"
            echo -e "${green}$(msg msg_wbp_new "${config_webBasePath}")${plain}"

            # If the panel is already installed but no certificate is configured, prompt for SSL now
            if [[ -z "${existing_cert}" ]]; then
                echo ""
                echo -e "${green}═══════════════════════════════════════════${plain}"
                echo -e "${green}     $(msg msg_ssl_title)${plain}"
                echo -e "${green}═══════════════════════════════════════════${plain}"
                echo -e "${yellow}$(msg msg_ssl_le_note)${plain}"
                echo ""
                if ! prompt_and_setup_ssl "${existing_port}" "${config_webBasePath}" "${server_ip}"; then
                    echo -e "${red}$(msg msg_abort1)${plain}"
                    echo -e "${red}$(msg msg_abort2)${plain}"
                    exit 1
                fi
                echo -e "${green}$(msg msg_done_url) ${SSL_SCHEME}://${SSL_HOST}:${existing_port}/${config_webBasePath}${plain}"
            else
                # If a cert already exists, just show the access URL
                echo -e "${green}$(msg msg_done_url) https://${server_ip}:${existing_port}/${config_webBasePath}${plain}"
            fi
        fi
    else
        if [[ "$existing_hasDefaultCredential" == "true" ]]; then
            local config_username="${EASYXRAY_USERNAME:-$(gen_random_string 10)}"
            local config_password="${EASYXRAY_PASSWORD:-$(gen_random_string 10)}"

            echo -e "${yellow}$(msg msg_default_creds)${plain}"
            ${easyxray_folder}/easyxray setting -username "${config_username}" -password "${config_password}"
            echo -e "$(msg msg_new_creds)"
            echo -e "###############################################"
            echo -e "${green}$(msg msg_done_user) ${config_username}${plain}"
            echo -e "${green}$(msg msg_done_pass) ${config_password}${plain}"
            echo -e "###############################################"

            # Persist a machine-parseable credentials file for cloud-init / MOTD.
            local config_apiToken
            config_apiToken=$(${easyxray_folder}/easyxray setting -getApiToken | grep -Eo 'apiToken: .+' | awk '{print $2}')
            : "${SSL_SCHEME:=https}"
            : "${SSL_HOST:=${server_ip}}"
            write_install_result "${config_username}" "${config_password}" "${existing_port}" \
                "${existing_webBasePath}" "${SSL_SCHEME}" "${SSL_HOST}" "${config_apiToken}" "${EASYXRAY_DB_TYPE:-sqlite}"
        else
            echo -e "${green}$(msg msg_creds_set)${plain}"
        fi

        # Existing install: if no cert configured, prompt user for SSL setup
        # Properly detect empty cert by checking if cert: line exists and has content after it
        existing_cert=$(${easyxray_folder}/easyxray setting -getCert true | grep 'cert:' | awk -F': ' '{print $2}' | tr -d '[:space:]')
        if [[ -z "$existing_cert" ]]; then
            echo ""
            echo -e "${green}═══════════════════════════════════════════${plain}"
            echo -e "${green}     $(msg msg_ssl_title)${plain}"
            echo -e "${green}═══════════════════════════════════════════${plain}"
            echo -e "${yellow}$(msg msg_ssl_le_note)${plain}"
            echo ""
            if ! prompt_and_setup_ssl "${existing_port}" "${existing_webBasePath}" "${server_ip}"; then
                echo -e "${red}$(msg msg_abort1)${plain}"
                echo -e "${red}$(msg msg_abort2)${plain}"
                exit 1
            fi
            echo -e "${green}$(msg msg_done_url) ${SSL_SCHEME}://${SSL_HOST}:${existing_port}/${existing_webBasePath}${plain}"
        else
            echo -e "${green}$(msg msg_ssl_already_configured)${plain}"
        fi
    fi

    ${easyxray_folder}/easyxray migrate
}

# setup_fail2ban auto-installs and configures fail2ban for the IP Limit feature
# by invoking the freshly installed easyxray CLI. IP Limit is load-bearing on
# fail2ban (without it the panel disables the limitIp field and zeroes existing
# limits), so a fresh install should make it work out of the box, just like the
# Docker image already does. Non-fatal by design: a fail2ban failure must never
# abort the panel install.
setup_fail2ban() {
    if [[ -n "${EASYXRAY_ENABLE_FAIL2BAN+x}" && "${EASYXRAY_ENABLE_FAIL2BAN}" != "true" ]]; then
        echo -e "${yellow}$(msg msg_f2b_skipped_env "${EASYXRAY_ENABLE_FAIL2BAN}")${plain}"
        return 0
    fi

    if [[ ! -x /usr/bin/easyxray ]]; then
        echo -e "${yellow}$(msg msg_f2b_skipped_cli)${plain}"
        return 0
    fi

    # Upstream 3x-ui scripts older than its v3.4.0 have no setup-fail2ban and
    # exit 0 from the usage banner, which would read as success here.
    if ! grep -q '"setup-fail2ban")' /usr/bin/easyxray; then
        echo -e "${yellow}$(msg msg_f2b_skipped_old)${plain}"
        return 0
    fi

    echo -e "${green}$(msg msg_f2b_setup)${plain}"
    if /usr/bin/easyxray setup-fail2ban; then
        echo -e "${green}$(msg msg_f2b_done)${plain}"
    else
        echo -e "${yellow}$(msg msg_f2b_incomplete)${plain}"
    fi
    return 0
}

# Major version of the local systemd, 0 when it cannot be determined. The
# SystemCallFilter=@system-service group only exists from systemd 239 on (other
# @-named groups exist since 231); on older versions an unknown group is not
# ignored safely, the filter stays in force and leaves a whitelist the panel
# cannot run under.
_easyxray_systemd_major_version() {
    local version=""
    if command -v systemctl > /dev/null 2>&1; then
        version="$(systemctl --version 2>/dev/null | awk 'NR == 1 {print $2}')"
    fi
    if [[ ! "$version" =~ ^[0-9]+$ ]]; then
        echo 0
        return 0
    fi
    echo "$version"
}

# The shipped units list hardening that older systemd does not know: the
# directive is logged and ignored at load time rather than rejected, so the
# panel still starts, only without that protection. Each entry is the systemd
# release that introduced the directive (systemd.exec(5)); everything else in
# the unit predates the oldest systemd install.sh supports (CentOS 7 has 219).
# SystemCallFilter= is listed because the drop-in only writes it from 239 on.
_easyxray_warn_unsupported_hardening() {
    local version entry missing=""
    version="$(_easyxray_systemd_major_version)"
    [[ "$version" -gt 0 ]] || return 0
    for entry in RestrictRealtime:231 ReadWritePaths:231 ProtectKernelTunables:232 \
        ProtectKernelModules:232 RestrictNamespaces:233 LockPersonality:235 \
        SystemCallFilter:239 ProtectHostname:242 RestrictSUIDSGID:242 \
        ProtectKernelLogs:244 ProtectClock:245; do
        if [[ "$version" -lt "${entry##*:}" ]]; then
            missing="${missing:+$missing, }${entry%%:*} (${entry##*:})"
        fi
    done
    [[ -n "$missing" ]] || return 0
    echo -e "${yellow}$(msg msg_systemd_hardening_note "${version}")${plain}"
    echo "$(msg msg_systemd_hardening_missing "${missing}")"
    if [[ "$version" -lt 231 ]]; then
        echo "$(msg msg_systemd_hardening_alias)"
    fi
    echo "$(msg msg_systemd_hardening_rest)"
    return 0
}

# ProtectSystem=full makes /usr, /boot, /efi and /etc read-only. ProtectSystem=
# strict would make the whole hierarchy read-only (only the kernel API
# filesystems stay as they are), and that would break the panel's own use of
# /tmp. The panel's stores are configurable (EASYXRAY_DB_FOLDER, EASYXRAY_LOG_FOLDER,
# EASYXRAY_BIN_FOLDER), and EASYXRAY_MAIN_FOLDER is the folder install.sh/update.sh place
# the files in -- the unit's WorkingDirectory on a stock install, and what a
# relative EASYXRAY_BIN_FOLDER is resolved against. So a hard-coded list in the unit
# either misses a relocated store -- the panel then cannot write its own SQLite
# database and sits in a Restart=on-failure loop -- or forces the operator to
# edit a file that every install/update overwrites from the release tarball.
# install.sh and update.sh therefore regenerate the drop-in from the folders
# actually in use, and the unit's own ReadWritePaths only carry the
# plain-install defaults. A relocated store means re-running install or update:
# the drop-in is only written here.
_easyxray_service_write_paths_dropin() {
    # $1 is the env file to resolve the EASYXRAY_* folders from; callers pass nothing
    # and get the OS-specific path the unit itself uses.
    local env_file="${1:-}"
    local dropin_dir dropin temp_file
    local db_folder log_folder bin_folder main_folder
    local path line="" whitespace_paths="" seen_paths="" escaped_path

    if [[ -z "$env_file" ]]; then
        case "${release}" in
            ubuntu | debian | armbian)
                env_file="/etc/default/easyxray"
                ;;
            arch | manjaro | parch | alpine)
                env_file="/etc/conf.d/easyxray"
                ;;
            *)
                env_file="/etc/sysconfig/easyxray"
                ;;
        esac
    fi
    if [[ -r "$env_file" ]]; then
        set -a
        # shellcheck disable=SC1090
        source "$env_file"
        set +a
    fi

    # EASYXRAY_* wins over the script's own default: the unit hands that same env
    # file to the panel through EnvironmentFile=, so these are the folders it
    # will actually use.
    main_folder="${EASYXRAY_MAIN_FOLDER:-${easyxray_folder}}"
    db_folder="${EASYXRAY_DB_FOLDER:-/etc/easyxray}"
    log_folder="${EASYXRAY_LOG_FOLDER:-/var/log/easyxray}"
    # An empty EASYXRAY_BIN_FOLDER resolves to "bin" relative to the panel's working
    # directory, which the unit sets to the main folder.
    bin_folder="${EASYXRAY_BIN_FOLDER:-bin}"
    if [[ "$bin_folder" != /* ]]; then
        bin_folder="${main_folder%/}/${bin_folder#./}"
    fi

    for path in "$db_folder" "$log_folder" "$bin_folder" "$main_folder"; do
        [[ "$path" == /* ]] || continue
        # ReadWritePaths= is a whitespace-separated list, and a folder whose
        # name contains whitespace cannot be written into it without relying on
        # quoting. A wrong entry makes systemd reject the whole drop-in and the
        # panel would not start, so leave such a folder out and say so instead.
        if [[ "$path" != "${path//[[:space:]]/}" ]]; then
            whitespace_paths="${whitespace_paths:+$whitespace_paths }$path"
            continue
        fi
        case " $seen_paths " in
            *" $path "*) continue ;;
        esac
        seen_paths="${seen_paths}${seen_paths:+ }$path"
        # systemd expands %-specifiers in unit files, so a folder name carrying
        # a literal % has to be written as %%, or the entry stops naming the
        # folder systemd is meant to keep writable.
        escaped_path="${path//%/%%}"
        line="${line} -${escaped_path}"
    done
    if [[ -n "$whitespace_paths" ]]; then
        echo "$(msg msg_ws_warn_head)" >&2
        echo "$(msg msg_ws_warn_detail "$whitespace_paths")" >&2
        echo "$(msg msg_ws_warn_tail)" >&2
    fi
    line="${line# }"
    [[ -n "$line" ]] || return 1

    dropin_dir="${easyxray_service}/easyxray.service.d"
    dropin="${dropin_dir}/10-easyxray-sandbox.conf"
    temp_file="${dropin}.tmp.$$"

    mkdir -p "$dropin_dir" || return 1
    cat > "$temp_file" << EOF
# Regenerated by install.sh/update.sh on every install and update: edits here
# are lost, and the list only reflects the EASYXRAY_* variables read from
# ${env_file} at that moment. Re-run install/update after moving a store.
# It lists the folders the panel writes to. Put local additions in their own
# drop-in, for example 20-easyxray-local.conf, which nothing here touches.
[Service]
ReadWritePaths=${line}
ReadWriteDirectories=${line}
EOF
    if [[ "$(_easyxray_systemd_major_version)" -ge 239 ]]; then
        cat >> "$temp_file" << 'EOF'
# @system-service needs systemd >= 239; on older versions the unknown group
# would leave the panel with a filter it cannot start under (easyxray.service.*).
SystemCallFilter=@system-service
SystemCallErrorNumber=EPERM
EOF
    fi
    if [[ ! -s "$temp_file" ]]; then
        rm -f "$temp_file"
        return 1
    fi
    chmod 644 "$temp_file"
    mv -f "$temp_file" "$dropin" || { rm -f "$temp_file"; return 1; }
    if command -v systemctl > /dev/null 2>&1; then
        systemctl daemon-reload > /dev/null 2>&1 || true
    fi
    return 0
}

# Lands a systemd unit file at ${easyxray_service}/easyxray.service via a temp file +
# atomic mv, so a failed cp/curl or an interrupted mv never leaves a
# truncated unit file at the live path -- systemd would then fail to parse
# it on the next daemon-reload/start. Same pattern already used for
# /usr/bin/easyxray elsewhere in this script. source_is_url picks cp (from a
# file already extracted from the release tarball) vs curl (GitHub fallback).
_install_easyxray_service_unit() {
    local source="$1"
    local source_is_url="$2"
    local dest="${easyxray_service}/easyxray.service"
    local temp_file="${dest}.tmp.$$"

    rm -f "$temp_file"
    if [[ "$source_is_url" == "true" ]]; then
        curl -fLRo "$temp_file" "$source" > /dev/null 2>&1
    else
        cp -f "$source" "$temp_file" > /dev/null 2>&1
    fi
    if [[ $? -ne 0 ]]; then
        rm -f "$temp_file"
        return 1
    fi
    if [[ ! -s "$temp_file" ]]; then
        rm -f "$temp_file"
        return 1
    fi
    mv -f "$temp_file" "$dest"
    if [[ $? -ne 0 ]]; then
        rm -f "$temp_file"
        return 1
    fi
    if ! _easyxray_service_write_paths_dropin; then
        echo -e "${yellow}$(msg msg_sandbox_refresh_failed "${easyxray_service}")${plain}"
        echo -e "${yellow}$(msg msg_sandbox_write_hint)${plain}"
    fi
    _easyxray_warn_unsupported_hardening
    return 0
}

# resolve_latest_tag prints the latest stable release tag. It prefers the web
# releases/latest redirect, which is not subject to the unauthenticated API's
# 60 req/h-per-IP limit that trips shared CI/CGNAT addresses (the install then
# fails with "Failed to fetch easyxray version"), and falls back to the API.
resolve_latest_tag() {
    local url tag
    url=$(curl -sSLI -o /dev/null -w '%{url_effective}' --retry 5 --retry-delay 3 --connect-timeout 15 --max-time 60 "https://github.com/EasyXrayTeam/EasyXray/releases/latest" 2>/dev/null)
    tag=${url##*/tag/}
    if [[ "$tag" != "$url" && -n "$tag" && "$tag" != "latest" ]]; then
        echo "$tag"
        return 0
    fi
    curl -Ls --retry 5 --retry-delay 3 --connect-timeout 15 --max-time 60 "https://api.github.com/repos/EasyXrayTeam/EasyXray/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Releases publish <asset>.sha256 next to each archive. A mismatch or a failed
# sidecar download aborts the install; only a 404 (releases predating the
# sidecar) is tolerated with a warning.
verify_release_checksum() {
    local url="$1" file="$2" sums="$2.sha256" code expected actual
    rm -f "${sums}"
    code=$(curl -sL --retry 3 --retry-delay 3 --connect-timeout 15 --max-time 60 -o "${sums}" -w '%{http_code}' "${url}.sha256")
    if [[ "${code}" == "404" ]]; then
        rm -f "${sums}"
        echo -e "${yellow}$(msg msg_checksum_none)${plain}"
        return 0
    fi
    if [[ "${code}" != "200" ]]; then
        rm -f "${sums}" "${file}"
        echo -e "${red}$(msg msg_checksum_download_failed "$(basename "${file}")" "${code}")${plain}"
        exit 1
    fi
    expected=$(awk 'NR == 1 {print $1}' "${sums}")
    actual=$(sha256sum "${file}" | awk '{print $1}')
    rm -f "${sums}"
    if [[ ! "${expected}" =~ ^[0-9a-f]{64}$ || "${expected}" != "${actual}" ]]; then
        rm -f "${file}"
        echo -e "${red}$(msg msg_checksum_mismatch "$(basename "${file}")" "${expected:-<none>}" "${actual}")${plain}"
        exit 1
    fi
    echo -e "${green}$(msg msg_checksum_ok "${actual}")${plain}"
}

# Older tags predate some of these files (easyxray.rc arrived in v2.8.4). Serving
# main's copy against an old binary is the mismatch this pinning exists to
# prevent, so probe before anything is stopped or removed and refuse the tag.
require_repo_files() {
    local ref="$1" name status
    shift
    [[ "${ref}" == "main" ]] && return 0
    for name in "$@"; do
        status=$(curl -sIL --retry 3 --connect-timeout 15 -o /dev/null -w '%{http_code}' "https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/${ref}/${name}")
        if [[ "${status}" != "200" ]]; then
            echo -e "${red}$(msg msg_repo_file_missing "${name}" "${ref}" "${status}")${plain}"
            echo -e "${red}$(msg msg_repo_file_missing_hint)${plain}"
            exit 1
        fi
    done
}

install_easyxray() {
    cd ${easyxray_folder%/easyxray}/

    # Download resources
    if [ $# == 0 ]; then
        tag_version=$(resolve_latest_tag)
        if [[ ! -n "$tag_version" ]]; then
            echo -e "${red}$(msg msg_version_fetch_failed)${plain}"
            exit 1
        fi
        echo -e "$(msg msg_latest_version "${tag_version}")"
        curl -fLR --retry 5 --retry-delay 3 --connect-timeout 15 --speed-limit 1 --speed-time 300 -o ${easyxray_folder}-linux-$(arch).tar.gz https://github.com/EasyXrayTeam/EasyXray/releases/download/${tag_version}/easyxray-linux-$(arch).tar.gz
        if [[ $? -ne 0 ]]; then
            echo -e "${red}$(msg msg_download_failed)${plain}"
            exit 1
        fi
        if [[ ! -s ${easyxray_folder}-linux-$(arch).tar.gz ]]; then
            rm ${easyxray_folder}-linux-$(arch).tar.gz -f
            echo -e "${red}$(msg msg_archive_empty)${plain}"
            exit 1
        fi
        verify_release_checksum "https://github.com/EasyXrayTeam/EasyXray/releases/download/${tag_version}/easyxray-linux-$(arch).tar.gz" "${easyxray_folder}-linux-$(arch).tar.gz"
    else
        tag_version=$1
        # No version floor: the inherited one encoded upstream 3.x numbering and
        # so rejected this project's own tags. The tag is validated further down
        # by require_repo_files and the published checksum.

        # The rolling dev channel ships under a fixed, non-semver tag that is
        # force-moved to the latest main commit on every push. Accept `dev` as a
        # convenient alias.
        if [[ "$tag_version" == "dev" || "$tag_version" == "dev-latest" ]]; then
            tag_version="dev-latest"
            echo -e "${yellow}$(msg msg_dev_build)${plain}"
        fi

        url="https://github.com/EasyXrayTeam/EasyXray/releases/download/${tag_version}/easyxray-linux-$(arch).tar.gz"
        echo -e "$(msg msg_install_start) easyxray ${tag_version}"
        curl -fLR --retry 5 --retry-delay 3 --connect-timeout 15 --speed-limit 1 --speed-time 300 -o ${easyxray_folder}-linux-$(arch).tar.gz ${url}
        if [[ $? -ne 0 ]]; then
            echo -e "${red}$(msg msg_download_version_failed "${tag_version}")${plain}"
            exit 1
        fi
        if [[ ! -s ${easyxray_folder}-linux-$(arch).tar.gz ]]; then
            rm ${easyxray_folder}-linux-$(arch).tar.gz -f
            echo -e "${red}$(msg msg_archive_empty)${plain}"
            exit 1
        fi
        verify_release_checksum "${url}" "${easyxray_folder}-linux-$(arch).tar.gz"
    fi
    # easyxray.sh, easyxray.rc and the unit files must come from the same release as
    # the binary; only the rolling dev build tracks main.
    local script_ref="${tag_version}"
    if [[ "${tag_version}" == "dev-latest" ]]; then
        script_ref="main"
    fi
    # The unit files are only fetched when the release tarball lacks them, so
    # they are checked at that point instead of here.
    local required_files=("easyxray.sh")
    [[ $release == "alpine" ]] && required_files+=("easyxray.rc")
    require_repo_files "${script_ref}" "${required_files[@]}"
    local easyxray_script_temp="/usr/bin/easyxray-temp.$$"
    rm -f "${easyxray_script_temp}"
    curl -fLRo "${easyxray_script_temp}" "https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/${script_ref}/easyxray.sh"
    if [[ $? -ne 0 ]]; then
        rm -f "${easyxray_script_temp}"
        echo -e "${red}$(msg msg_script_download_failed)${plain}"
        exit 1
    fi
    if [[ ! -s "${easyxray_script_temp}" ]]; then
        rm -f "${easyxray_script_temp}"
        echo -e "${red}$(msg msg_script_empty)${plain}"
        exit 1
    fi

    # Stop easyxray service and remove old resources
    local custom_bin_backup=""
    if [[ -e ${easyxray_folder}/ ]]; then
        if [[ $release == "alpine" ]]; then
            rc-service easyxray stop
        else
            systemctl stop easyxray
        fi
        # Kill any leftover mtg (MTProto) sidecars. easyxray runs them outside its own
        # lifecycle, so on Linux a stale one can survive the stop and keep holding
        # an inbound port with an outdated secret, silently breaking new clients.
        # The freshly installed panel respawns a clean mtg per inbound on start.
        pkill -f 'mtg-linux-[^ ]* run ' > /dev/null 2>&1 || true
        pkill -f 'tuic-server.*-c .*bin/tuic/tuic_[0-9]+\.json' > /dev/null 2>&1 || true

        # bin/ is about to be wiped wholesale by the tar extraction below. The
        # release only ships known assets (xray/mtg binaries, the bundled
        # geoip*/geosite*.dat sets) -- anything else in bin/ was placed there
        # by the admin (e.g. a hand-added custom geoip/geosite file referenced
        # from a routing rule via "ext:<file>:<code>") and would otherwise be
        # silently deleted on every update, breaking Xray at next start with
        # "failed to open <file>: no such file or directory" for any routing
        # rule that references it. Moved aside rather than copied: a rename
        # on the same filesystem is atomic (no truncated file if disk space
        # runs out mid-copy, unlike `cp`) and keeps the snapshot under
        # /usr/local rather than a separate, possibly small/tmpfs $TMPDIR.
        if [[ -d "${easyxray_folder}/bin" ]]; then
            custom_bin_backup="${easyxray_folder%/easyxray}/easyxray-bin-backup.$$"
            rm -rf "${custom_bin_backup}"
            if ! mv "${easyxray_folder}/bin" "${custom_bin_backup}"; then
                custom_bin_backup=""
                echo -e "${yellow}$(msg msg_bin_backup_failed)${plain}"
            fi
        fi
        # Sole cleanup path for the backup from here on -- covers both the
        # two `exit 1`s below (extraction/binary-missing failures) and an
        # interrupted update (Ctrl-C, signal) before the restore runs.
        # Cleared once the restore below finishes normally.
        trap '[[ -n "${custom_bin_backup}" ]] && rm -rf "${custom_bin_backup}"' EXIT INT TERM
        rm ${easyxray_folder}/ -rf
    fi

    # Extract resources and set permissions
    tar zxvf easyxray-linux-$(arch).tar.gz
    if [[ $? -ne 0 ]]; then
        rm easyxray-linux-$(arch).tar.gz -f
        rm -f "${easyxray_script_temp}"
        echo -e "${red}$(msg msg_extract_failed)${plain}"
        exit 1
    fi
    rm easyxray-linux-$(arch).tar.gz -f

    cd easyxray
    if [[ $? -ne 0 || ! -s easyxray ]]; then
        rm -f "${easyxray_script_temp}"
        echo -e "${red}$(msg msg_binary_missing)${plain}"
        exit 1
    fi
    chmod +x easyxray
    chmod +x easyxray.sh

    # Check the system's architecture and rename the file accordingly.
    # The panel binary maps GOARCH=arm to "arm32" (internal/xray/process.go),
    # so the Xray binary must be named xray-linux-arm32; mtg keeps plain "arm".
    if [[ $(arch) == "armv5" || $(arch) == "armv6" || $(arch) == "armv7" ]]; then
        mv bin/xray-linux-$(arch) bin/xray-linux-arm32
        chmod +x bin/xray-linux-arm32
        if [[ -f bin/mtg-linux-$(arch) ]]; then
            mv bin/mtg-linux-$(arch) bin/mtg-linux-arm
            chmod +x bin/mtg-linux-arm
        fi
    fi
    chmod +x easyxray bin/xray-linux-$(arch)
    if [[ -f bin/mtg-linux-arm ]]; then
        chmod +x bin/mtg-linux-arm
    elif [[ -f bin/mtg-linux-$(arch) ]]; then
        chmod +x bin/mtg-linux-$(arch)
    fi

    # Restore anything from the old bin/ that the fresh release doesn't ship
    # (custom geoip/geosite files, or anything else an admin hand-placed
    # there) -- never overwrites a same-named file the new release provides,
    # so bundled assets (geoip.dat, geoip_RU.dat, ...) still get the fresh
    # per-release copy. Runs after the arch-rename above so xray-linux-arm32/
    # mtg-linux-arm already exist under their final names there and aren't
    # mistaken for custom files needing a restore. Skips paths the panel
    # itself regenerates at runtime (config.json, mtproto/*.toml -- see
    # internal/xray/process.go, internal/mtproto/manager.go): those aren't
    # admin-placed, and restoring a stale one only resurrects dead state (an
    # orphaned mtg config for a since-deleted inbound) or the wrong
    # directory permissions.
    if [[ -n "${custom_bin_backup}" ]]; then
        local restored_custom_bin=()
        while IFS= read -r -d '' f; do
            local rel="${f#"${custom_bin_backup}"/}"
            case "${rel}" in
                config.json | mtproto | mtproto/* | tuic | tuic/* | tuic-server | tuic-server-*) continue ;;
            esac
            if [[ ! -e "bin/${rel}" ]]; then
                mkdir -p "bin/$(dirname "${rel}")"
                cp -a "${f}" "bin/${rel}"
                restored_custom_bin+=("${rel}")
            fi
        done < <(find "${custom_bin_backup}" \( -type f -o -type l \) -print0)
        rm -rf "${custom_bin_backup}"
        custom_bin_backup=""
        if [[ ${#restored_custom_bin[@]} -gt 0 ]]; then
            echo -e "${green}$(msg msg_bin_restored "${restored_custom_bin[*]}")${plain}"
        fi
    fi
    trap - EXIT INT TERM

    rm -f bin/tuic-server bin/tuic-server-* > /dev/null 2>&1 || true
    rm -rf bin/tuic > /dev/null 2>&1 || true

    # Update easyxray cli and se set permission
    mv -f "${easyxray_script_temp}" /usr/bin/easyxray
    if [[ $? -ne 0 ]]; then
        rm -f "${easyxray_script_temp}"
        echo -e "${red}$(msg msg_script_install_failed)${plain}"
        exit 1
    fi
    chmod +x /usr/bin/easyxray
    mkdir -p /var/log/easyxray
    config_after_install

    # Etckeeper compatibility
    if [ -d "/etc/.git" ]; then
        if [ -f "/etc/.gitignore" ]; then
            if ! grep -q "easyxray/EasyXray.db" "/etc/.gitignore"; then
                echo "" >> "/etc/.gitignore"
                echo "easyxray/EasyXray.db" >> "/etc/.gitignore"
                echo -e "${green}$(msg msg_gitignore_added)${plain}"
            fi
        else
            echo "easyxray/EasyXray.db" > "/etc/.gitignore"
            echo -e "${green}$(msg msg_gitignore_created)${plain}"
        fi
    fi

    if [[ $release == "alpine" ]]; then
        easyxray_rc_temp="/etc/init.d/easyxray.tmp.$$"
        rm -f "${easyxray_rc_temp}"
        curl -fLRo "${easyxray_rc_temp}" "https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/${script_ref}/easyxray.rc"
        if [[ $? -ne 0 ]]; then
            rm -f "${easyxray_rc_temp}"
            echo -e "${red}$(msg msg_rc_download_failed)${plain}"
            exit 1
        fi
        if [[ ! -s "${easyxray_rc_temp}" ]]; then
            rm -f "${easyxray_rc_temp}"
            echo -e "${red}$(msg msg_rc_empty)${plain}"
            exit 1
        fi
        mv -f "${easyxray_rc_temp}" /etc/init.d/easyxray
        if [[ $? -ne 0 ]]; then
            rm -f "${easyxray_rc_temp}"
            echo -e "${red}$(msg msg_rc_install_failed)${plain}"
            exit 1
        fi
        chmod +x /etc/init.d/easyxray
        rc-update add easyxray
        rc-service easyxray start
    else
        # Install systemd service file
        service_installed=false

        if [ -f "easyxray.service" ]; then
            echo -e "${green}$(msg msg_service_found)${plain}"
            if _install_easyxray_service_unit "easyxray.service" "false"; then
                service_installed=true
            fi
        fi

        if [ "$service_installed" = false ]; then
            case "${release}" in
                ubuntu | debian | armbian)
                    if [ -f "easyxray.service.debian" ]; then
                        echo -e "${green}$(msg msg_service_found_variant "debian")${plain}"
                        if _install_easyxray_service_unit "easyxray.service.debian" "false"; then
                            service_installed=true
                        fi
                    fi
                    ;;
                arch | manjaro | parch)
                    if [ -f "easyxray.service.arch" ]; then
                        echo -e "${green}$(msg msg_service_found_variant "arch")${plain}"
                        if _install_easyxray_service_unit "easyxray.service.arch" "false"; then
                            service_installed=true
                        fi
                    fi
                    ;;
                *)
                    if [ -f "easyxray.service.rhel" ]; then
                        echo -e "${green}$(msg msg_service_found_variant "rhel")${plain}"
                        if _install_easyxray_service_unit "easyxray.service.rhel" "false"; then
                            service_installed=true
                        fi
                    fi
                    ;;
            esac
        fi

        # If service file not found in tar.gz, download from GitHub
        if [ "$service_installed" = false ]; then
            echo -e "${yellow}$(msg msg_service_downloading)${plain}"
            case "${release}" in
                ubuntu | debian | armbian)
                    service_unit_url="https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/${script_ref}/easyxray.service.debian"
                    ;;
                arch | manjaro | parch)
                    service_unit_url="https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/${script_ref}/easyxray.service.arch"
                    ;;
                *)
                    service_unit_url="https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/${script_ref}/easyxray.service.rhel"
                    ;;
            esac

            if ! _install_easyxray_service_unit "$service_unit_url" "true"; then
                echo -e "${red}$(msg msg_service_install_failed "${script_ref}")${plain}"
                exit 1
            fi
            service_installed=true
        fi

        if [ "$service_installed" = true ]; then
            echo -e "${green}$(msg msg_systemd_setup)${plain}"
            chown root:root ${easyxray_service}/easyxray.service > /dev/null 2>&1
            chmod 644 ${easyxray_service}/easyxray.service > /dev/null 2>&1
            systemctl daemon-reload
            systemctl enable easyxray
            systemctl start easyxray
        else
            echo -e "${red}$(msg msg_service_file_failed)${plain}"
            exit 1
        fi
    fi

    # IP Limit relies on fail2ban; install + configure it now so the feature
    # works out of the box (no-op when EASYXRAY_ENABLE_FAIL2BAN=false). Never fatal.
    setup_fail2ban

    echo -e "${green}easyxray ${tag_version}${plain} $(msg msg_installed_ok)"
    echo -e ""
    print_usage_box
}

echo -e "${green}$(msg msg_running)${plain}"
install_base
install_easyxray $1
