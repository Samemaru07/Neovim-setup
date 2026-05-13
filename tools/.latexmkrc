# 中間ファイルの出力先
$out_dir = '.build';

# upLaTeX + dvipdfmx で PDF を生成
$pdf_mode = 3;
$latex   = 'uplatex %O %S';
$dvipdf  = 'dvipdfmx %O -o %D %S';

# ビルド成功後、PDFをプロジェクトルートにコピー
$success_cmd = 'cp "%D" "%R.pdf"';
