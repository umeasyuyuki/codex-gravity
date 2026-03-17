"use server";

import { addCallLog, deleteCallLog, updateCallLogCalledAt } from "@/lib/actions/applicant"

function parseBooleanValue(rawValue: FormDataEntryValue | null) {
    return rawValue === "on" || rawValue === "1" || rawValue === "true"
}

export async function createCallLogAction(formData: FormData) {
    "use server"
    const applicantId = String(formData.get("applicantId") || "").trim()
    const calledAt = String(formData.get("calledAt") || "")
    const note = String(formData.get("note") || "").trim()
    const isConnected = formData.get("isConnected")

    if (!applicantId) {
        throw new Error("応募者を選択してください。")
    }

    await addCallLog({
        applicantId,
        isConnected: parseBooleanValue(isConnected),
        note: note || null,
        calledAt: calledAt || undefined,
    })
}

export async function deleteCallLogAction(formData: FormData) {
    "use server"
    const callLogId = String(formData.get("callLogId") || "")
    await deleteCallLog(callLogId)
}

export async function updateCallLogCalledAtAction(formData: FormData) {
    "use server"
    const callLogId = String(formData.get("callLogId") || "").trim()
    const calledAt = String(formData.get("calledAt") || "").trim()
    if (!callLogId || !calledAt) {
        throw new Error("架電ログIDと日時を指定してください。")
    }
    await updateCallLogCalledAt(callLogId, calledAt)
}
