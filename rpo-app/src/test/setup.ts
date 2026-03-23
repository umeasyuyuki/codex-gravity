import { afterEach, beforeEach, vi } from "vitest"
import * as realSchema from "@/db/schema"

function createChain() {
    const chain: Record<string, ReturnType<typeof vi.fn>> = {
        from: vi.fn(),
        innerJoin: vi.fn(),
        where: vi.fn(),
        orderBy: vi.fn(),
        limit: vi.fn(),
        offset: vi.fn(),
        leftJoin: vi.fn(),
        set: vi.fn(),
        all: vi.fn().mockResolvedValue([]),
        get: vi.fn().mockResolvedValue(undefined),
        values: vi.fn(),
        returning: vi.fn().mockResolvedValue([]),
    }
    const self = () => chain
    chain.from.mockImplementation(self)
    chain.innerJoin.mockImplementation(self)
    chain.where.mockImplementation(self)
    chain.orderBy.mockImplementation(self)
    chain.limit.mockImplementation(self)
    chain.offset.mockImplementation(self)
    chain.leftJoin.mockImplementation(self)
    chain.set.mockImplementation(self)
    chain.values.mockImplementation(self)
    return chain
}

function resetChain(chain: Record<string, ReturnType<typeof vi.fn>>) {
    const self = () => chain
    chain.from.mockReset().mockImplementation(self)
    chain.innerJoin.mockReset().mockImplementation(self)
    chain.where.mockReset().mockImplementation(self)
    chain.orderBy.mockReset().mockImplementation(self)
    chain.limit.mockReset().mockImplementation(self)
    chain.offset.mockReset().mockImplementation(self)
    chain.leftJoin.mockReset().mockImplementation(self)
    chain.set.mockReset().mockImplementation(self)
    chain.values.mockReset().mockImplementation(self)
    chain.all.mockReset().mockResolvedValue([])
    chain.get.mockReset().mockResolvedValue(undefined)
    chain.returning.mockReset().mockResolvedValue([])
}

const selectChain = createChain()
const insertChain = createChain()
const deleteChain = createChain()
const updateChain = createChain()

vi.mock("@/db", () => ({
    db: {
        select: vi.fn().mockReturnValue(selectChain),
        insert: vi.fn().mockReturnValue(insertChain),
        delete: vi.fn().mockReturnValue(deleteChain),
        update: vi.fn().mockReturnValue(updateChain),
        _selectChain: selectChain,
        _insertChain: insertChain,
        _deleteChain: deleteChain,
        _updateChain: updateChain,
    },
    schema: realSchema,
}))

vi.mock("@/lib/runtime-env", () => ({
    getRuntimeEnv: vi.fn(),
}))

beforeEach(() => {
    // Reset chain mocks to defaults before each test
    resetChain(selectChain)
    resetChain(insertChain)
    resetChain(deleteChain)
    resetChain(updateChain)
})
