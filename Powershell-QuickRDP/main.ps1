##################################################################
#                      *** Main Execution ***                    #
##################################################################

$remoteip = ""
$username = ""
$password = ""
$checkword = "rdp-tcp#"
$matchingsessions = "" # デフォルト値を空にしておく
$today = (Get-Date).ToString("yyyyMMdd")

##################################################################
#                  *** Function Definitions ***                  #
##################################################################

# ログ出力関数
function Write-Log {
    param (
        [string]$message, # ログメッセージ
        [string]$logLevel = "INFO", # ログレベル (INFO, ERROR, DEBUG など)
        [string]$logfile = "log/log_$today.txt"  # ログファイルのパス
    )
    # 日付を取得
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    # ログメッセージを日付とログレベルと共に構成
    $logMessage = "$timestamp [$logLevel] $message"

    # ログファイルに追加書き込み
    $logMessage | Out-File -FilePath $logfile -Append
}

# RDPプロセスが起動しているか取得する
function Get-Rdptask {
    $result = tasklist /v | Select-String "mstsc.exe"
    return $result
}

# リモートコマンドでRDPセッションの存在確認
function Get-RemoteRdpSession {
    param (
        [string]$remoteip,
        [System.Management.Automation.PSCredential]$cred
    )
    Invoke-Command -ComputerName $remoteip -Credential $cred -ScriptBlock {
        param ($remoteip)
        # リモートでRDPセッションを確認。安定してセッション情報を取得するため、5秒待機。
        start-sleep -s 5
        $sessions = qwinsta /server:$remoteip
        # セッション名の取得
        $sessionname = $sessions | Select-String -Pattern "^\s*(\S+)" | ForEach-Object { $_.Matches.Groups[1].Value }
        $matchingsessions = $sessionname | Where-Object { $_ -match "rdp-tcp#" }
        return $matchingsessions
    } -ArgumentList $remoteip
}

##################################################################
#                      *** Main Execution ***                    #
##################################################################

# credentialオブジェクトを作成
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $securePassword)

# RDP接続の認証情報を作成
cmdkey /add:$remoteip /user:$username /pass:$password

# RDPプロセスがローカルで起動しているか確認
if (Get-Rdptask) {
    Write-Log "RDP session is running locally."
}
else {
    Write-Log "No local RDP session found. Checking remote server..." -logLevel "WARNING"
    $count = 1
    $maxretries = 5

    # RDP接続を開始。リトライ5回で処理中断。
    while ($count -lt $maxretries) {
        mstsc /v:$remoteip
        Start-Sleep -Seconds 3
        if (Get-Rdptask) {
            # 接続先でセッションの存在を確認
            $result = Get-RemoteRdpSession $remoteip $cred
            if ($result -match $checkword) {
                Write-Log "RDP session established successfully!"
                break
            }
            else {
                Write-Log "$count attempt: RDP session failed." -logLevel "WARNING"
                # 接続失敗時にポップアップが表示され、タスクが残るためキルする
                taskkill /IM mstsc.exe /F
            }
        }
        if ($count -eq $maxretries) {
            Write-Log "$count attempts: Maximum retry limit reached." -logLevel "ERROR"
        }
        $count += 1
    }
}