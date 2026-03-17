import { Phone } from "lucide-react"
import CallLogsClient from "../CallLogsClient"
import { createCallLogAction, deleteCallLogAction, updateCallLogCalledAtAction } from "../actions"

export default async function CallLogsRegisterPage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-2xl font-bold tracking-tight text-foreground flex items-center gap-2">
                        <Phone className="w-6 h-6 text-primary" />
                        架電登録
                    </h1>
                    <p className="text-muted-foreground mt-0.5 text-[13px]">架電履歴を登録します</p>
                </div>
            </div>

            <CallLogsClient
                logs={[]}
                companies={[]}
                users={[]}
                viewMode="register"
                createCallLogAction={createCallLogAction}
                deleteCallLogAction={deleteCallLogAction}
                updateCalledAtAction={updateCallLogCalledAtAction}
            />
        </div>
    )
}
