import { vi } from "vitest"
import * as realSchema from "@/db/schema"

type MockTerminal = ReturnType<typeof vi.fn>

interface ChainableMock {
    from: ReturnType<typeof vi.fn>
    innerJoin: ReturnType<typeof vi.fn>
    where: ReturnType<typeof vi.fn>
    orderBy: ReturnType<typeof vi.fn>
    limit: ReturnType<typeof vi.fn>
    offset: ReturnType<typeof vi.fn>
    all: MockTerminal
    get: MockTerminal
    values: ReturnType<typeof vi.fn>
    returning: MockTerminal
}

function createChain(): ChainableMock {
    const chain: ChainableMock = {
        from: vi.fn(),
        innerJoin: vi.fn(),
        where: vi.fn(),
        orderBy: vi.fn(),
        limit: vi.fn(),
        offset: vi.fn(),
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
    chain.values.mockImplementation(self)

    return chain
}

export function createMockDb() {
    const selectChain = createChain()
    const insertChain = createChain()
    const deleteChain = createChain()
    const updateChain = createChain()

    const mockDb = {
        select: vi.fn().mockReturnValue(selectChain),
        insert: vi.fn().mockReturnValue(insertChain),
        delete: vi.fn().mockReturnValue(deleteChain),
        update: vi.fn().mockReturnValue(updateChain),
        _selectChain: selectChain,
        _insertChain: insertChain,
        _deleteChain: deleteChain,
        _updateChain: updateChain,
    }

    return {
        db: mockDb,
        schema: realSchema,
    }
}
