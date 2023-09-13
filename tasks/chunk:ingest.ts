import { ChunkStatus, StubStatus } from '@prisma/client'

import prisma from '../lib/database'
import { searchDiarium } from '../lib/ingestion'

function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(() => resolve(), ms))
}

;(async () => {
  const chunks = await prisma.chunk.findMany({
    where: { status: { in: [ChunkStatus.PENDING, ChunkStatus.ONGOING] } },
    orderBy: { created: 'asc' },
    include: { scan: true },
  })

  for (const chunk of chunks) {
    console.log(`${chunk.id} ${chunk.startDate} ${chunk.page}`)

    await prisma.$transaction(
      async (tx) => {
        const now = new Date()
        const result = await searchDiarium({
          FromDate: chunk.scan.date!.toISOString().substring(0, 10),
          ToDate: chunk.scan.date!.toISOString().substring(0, 10),
          page: chunk.page,
        })

        const documents = await tx.document.findMany({
          where: {
            code: {
              in: result.rows.map((r) => r.documentCode),
            },
          },
        })
        const documentCodes = documents.map((d) => d.code)
        const newDocuments = result.rows.filter((row) => {
          return !documentCodes.includes(row.documentCode)
        })

        const newStubs = await tx.stub.createMany({
          data: newDocuments.map((row, index) => ({
            chunkId: chunk.id,
            scanId: chunk.scanId,
            index,
            status: StubStatus.PENDING,
            caseName: row.caseName,
            documentCode: row.documentCode,
            documentDate: new Date(row.documentDate),
            documentType: row.documentType,
            companyName: row.companyName,
            created: now,
            updated: now,
          })),
        })

        await tx.chunk.update({
          where: { id: chunk.id },
          data: {
            hitCount: result.hitCount,
            stubCount: newStubs.count,
            status: StubStatus.SUCCESS,
          },
        })
      },
      {
        timeout: 15000,
      }
    )

    await delay(1000)
  }

  process.exit(0)
})()
